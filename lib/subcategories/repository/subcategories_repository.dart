import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../shared/models/subcategory.dart';
import 'package:http/http.dart' as http;

abstract class SubcategoriesRepository {
  final User user;

  const SubcategoriesRepository({required this.user});

  Stream<List<Subcategory>> getSubcategories();

  Future<void> saveSubcategory(
      {required String budgetId, required Subcategory subcategory});

  Future<List<Subcategory>> fetchSubcategories(
      {required String budgetId, required String categoryId});

  Future<void> delete({required Subcategory subcategory});
}

class SubcategoriesRepositoryImpl extends SubcategoriesRepository {
  static const baseURL = '10.0.2.2:8080';

  SubcategoriesRepositoryImpl({required super.user});

  final _subcategoriesStreamController =
      BehaviorSubject<List<Subcategory>>.seeded(const []);

  @override
  Stream<List<Subcategory>> getSubcategories() =>
      _subcategoriesStreamController.asBroadcastStream();

  @override
  Future<void> saveSubcategory(
      {required String budgetId, required Subcategory subcategory}) async {
    final url = Uri.http(baseURL, '/api/subcategories');

    final response = await http.post(url,
        headers: await _getHeaders(), body: json.encode(subcategory.toJson()));

    final newSubcategory = Subcategory.fromJson(jsonDecode(response.body));
    final subcategories = await fetchSubcategories(
        budgetId: newSubcategory.budgetId,
        categoryId: newSubcategory.categoryId);
    _subcategoriesStreamController.add(subcategories);
  }

  @override
  Future<List<Subcategory>> fetchSubcategories(
      {required String budgetId, required String categoryId}) async {
    final url =
        Uri.http(baseURL, '/api/subcategories', {'categoryId': categoryId});
    final response = await http.get(url, headers: await _getHeaders());

    final result = List<Map<String, dynamic>>.from(
      json.decode(response.body) as List,
    )
        .map((jsonMap) =>
            Subcategory.fromJson(Map<String, dynamic>.from(jsonMap)))
        .where((scat) => scat.categoryId == categoryId)
        .toList();

    return result;
  }

  @override
  Future<void> delete({required Subcategory subcategory}) async {
    final url = Uri.http(baseURL, '/api/subcategories/${subcategory.id}');

    await http.delete(url, headers: await _getHeaders());
    final subcategories = await fetchSubcategories(
        budgetId: subcategory.budgetId, categoryId: subcategory.categoryId);
    _subcategoriesStreamController.add(subcategories);
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await user.token;
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
  }
}
