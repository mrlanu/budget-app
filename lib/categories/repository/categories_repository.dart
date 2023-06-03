import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../models/category.dart';
import '../../transactions/models/transaction_type.dart';

abstract class CategoriesRepository {
  final User user;

  const CategoriesRepository({required this.user});

  Stream<List<Category>> getCategories();

  Future<List<Category>> fetchCategories(
      {required String budgetId, required TransactionType transactionType});

  Future<void> saveCategory({required Category category});

  Future<void> deleteCategory({required Category category});
}

class CategoriesRepositoryImpl extends CategoriesRepository {
  static const baseURL = '10.0.2.2:8080';

  final _categoriesStreamController =
      BehaviorSubject<List<Category>>.seeded(const []);

  CategoriesRepositoryImpl({required super.user});

  @override
  Stream<List<Category>> getCategories() =>
      _categoriesStreamController.asBroadcastStream();

  @override
  Future<List<Category>> fetchCategories(
      {required String budgetId,
      required TransactionType transactionType}) async {
    final url = Uri.http(baseURL, '/api/categories', {'budgetId': budgetId});

    final response = await http.get(url, headers: await _getHeaders());

    final result = List<Map<String, dynamic>>.from(
      json.decode(response.body) as List,
    )
        .map((jsonMap) => Category.fromJson(jsonMap))
        .where((cat) => cat.transactionType == transactionType)
        .toList();

    return result;
  }

  @override
  Future<void> saveCategory({required Category category}) async {
    final url = Uri.http(baseURL, '/api/categories');

    final response = await http.post(url,
        headers: await _getHeaders(), body: json.encode(category.toJson()));

    final newCategory = Category.fromJson(jsonDecode(response.body));
    final categories = await fetchCategories(
        budgetId: newCategory.budgetId,
        transactionType: newCategory.transactionType);

    _categoriesStreamController.add(categories);
  }

  @override
  Future<void> deleteCategory({required Category category}) async {
    final url = Uri.http(baseURL, '/api/categories/${category.id}');

    await http.delete(url, headers: await _getHeaders());
    final categories = await fetchCategories(
        budgetId: category.budgetId, transactionType: category.transactionType);
    _categoriesStreamController.add(categories);
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await user.token;
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
  }
}
