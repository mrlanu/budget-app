import 'dart:convert';
import 'package:authentication_repository/authentication_repository.dart';
import '../../categories/models/category_summary.dart';
import 'package:http/http.dart' as http;
import '../../sections/models/section_summary.dart';

abstract class SharedRepository {
  final User user;

  SharedRepository(this.user);

  Future<List<SectionSummary>> fetchAllSections();

  Future<List<CategorySummary>> fetchAllCategories(String section);
}

class SharedRepositoryImpl extends SharedRepository {
  SharedRepositoryImpl(super.user);

  static const baseURL = 'http://10.0.2.2:8080/api';

  @override
  Future<List<SectionSummary>> fetchAllSections() async {
    final url = '$baseURL/budgets/sections';

    final token = await user.token;
    final response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    final sections = List<Map<dynamic, dynamic>>.from(
      json.decode(response.body) as List,
    )
        .map((jsonMap) =>
            SectionSummary.fromJson(Map<String, dynamic>.from(jsonMap)))
        .toList();

    return sections;
  }

  @override
  Future<List<CategorySummary>> fetchAllCategories(String section) async {
    final url = '$baseURL/budgets/categories?section=$section';

    final token = await user.token;
    final response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    final result = List<Map<dynamic, dynamic>>.from(
      json.decode(response.body) as List,
    )
        .map((jsonMap) =>
            CategorySummary.fromJson(Map<String, dynamic>.from(jsonMap)))
        .toList();

    return result;
  }
}
