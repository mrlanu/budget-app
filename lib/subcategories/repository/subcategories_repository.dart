import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../shared/models/subcategory.dart';
import 'package:http/http.dart' as http;

abstract class SubcategoriesRepository {
  final User user;

  const SubcategoriesRepository({required this.user});

  Stream<List<Subcategory>> getSubcategories();
  Future<void> saveSubcategory({required String budgetId, required Subcategory subcategory});
  Future<List<Subcategory>> fetchSubcategories(
      {required String budgetId,
        required String categoryId});
}

class SubcategoriesRepositoryImpl extends SubcategoriesRepository {
  static const baseURL = 'http://10.0.2.2:8080/api';

  SubcategoriesRepositoryImpl({required super.user});

  final _subcategoriesStreamController =
  BehaviorSubject<List<Subcategory>>.seeded(const []);

  @override
  Stream<List<Subcategory>> getSubcategories() =>
      _subcategoriesStreamController.asBroadcastStream();

  @override
  Future<void> saveSubcategory({required String budgetId, required Subcategory subcategory}) async {
    final url = '$baseURL/$budgetId/subcategory';

    final response = await http.post(Uri.parse(url),
        headers: await _getHeaders(),
        body: json.encode(subcategory.toJson()));

    final newSubcategory = Subcategory.fromJson(jsonDecode(response.body));
    final subcategories = [..._subcategoriesStreamController.value];
    subcategories.add(newSubcategory);
    _subcategoriesStreamController.add(subcategories);
  }

  @override
  Future<List<Subcategory>> fetchSubcategories(
      {required String budgetId,
        required String categoryId}) async {
    final url = '$baseURL/$budgetId/subcategories';
    final response = await http.get(Uri.parse(url), headers: await _getHeaders());

    final result = List<Map<String, dynamic>>.from(
      json.decode(response.body) as List,
    )
        .map((jsonMap) => Subcategory.fromJson(Map<String, dynamic>.from(jsonMap)))
        .where((scat) => scat.categoryId == categoryId)
        .toList();

    _subcategoriesStreamController.add(result);

    return result;
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await user.token;
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
  }

}
