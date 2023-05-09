import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:http/http.dart' as http;

import '../../accounts/models/account_brief.dart';
import '../../categories/models/category.dart';
import '../../categories/models/category_summary.dart';
import '../../categories/models/subcategory.dart';
import '../../sections/models/section_summary.dart';
import '../models/budget.dart';

abstract class SharedRepository {
  final User user;
  Budget? budget;

  SharedRepository({required this.user, this.budget});

  Future<void> fetchBudget();

  Future<List<SectionSummary>> fetchAllSections();

  Future<List<CategorySummary>> fetchSummaryByCategory(String section);
}

class SharedRepositoryImpl extends SharedRepository {
  SharedRepositoryImpl({required super.user});

  static const baseURL = 'http://10.0.2.2:8080/api';

  Future<void> fetchBudget() async {
    final url = '$baseURL/budgets';

    final token = await user.token;
    final response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    final budgetMap = json.decode(response.body);
    final categoryList = List<Map<dynamic, dynamic>>.from(
            budgetMap['categoryList'])
        .map((jsonMap) => Category.fromJson(Map<String, dynamic>.from(jsonMap)))
        .toList();

    final subcategoryList =
        List<Map<dynamic, dynamic>>.from(budgetMap['subcategoryList'])
            .map((jsonMap) =>
                Subcategory.fromJson(Map<String, dynamic>.from(jsonMap)))
            .toList();

    final accountList =
        List<Map<dynamic, dynamic>>.from(budgetMap['accountBriefList'])
            .map((jsonMap) =>
                AccountBrief.fromJson(Map<String, dynamic>.from(jsonMap)))
            .toList();

    final budget = Budget(
      id: budgetMap['id'],
      userId: budgetMap['userId'],
      categoryList: categoryList,
      subcategoryList: subcategoryList,
      accountBriefList: accountList,
    );

    this.budget = budget;
  }

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
  Future<List<CategorySummary>> fetchSummaryByCategory(String section) async {
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
