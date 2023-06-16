import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../../shared/models/budget.dart';
import '../models/category.dart';
import '../../transactions/models/transaction_type.dart';

abstract class CategoriesRepository {
  final User user;
  final Budget budget;

  const CategoriesRepository({required this.user, required this.budget});

  Stream<List<Category>> getCategories();

  Future<List<Category>> fetchCategories(
      {required String budgetId, required TransactionType transactionType});

  Future<void> fetchAllCategories();

  Future<void> saveCategory({required Category category});

  Future<void> deleteCategory({required Category category});
}

class CategoryFailure implements Exception {
  final String message;

  const CategoryFailure([
    this.message = 'An unknown exception occurred.',
  ]);
}

class CategoriesRepositoryImpl extends CategoriesRepository {
  static const baseURL = '10.0.2.2:8080';

  final _categoriesStreamController =
      BehaviorSubject<List<Category>>.seeded(const []);

  CategoriesRepositoryImpl({required super.user, required super.budget});


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
  Future<void> fetchAllCategories() async {
    final url = Uri.http(baseURL, '/api/categories', {'budgetId': budget.id});

    final response = await http.get(url, headers: await _getHeaders());

    final result = List<Map<String, dynamic>>.from(
      json.decode(response.body) as List,
    ).map((jsonMap) => Category.fromJson(jsonMap)).toList();
    _categoriesStreamController.add(result);
  }

  @override
  Future<void> saveCategory({required Category category}) async {
    final url = Uri.http(baseURL, '/api/categories');
    await http.post(url,
        headers: await _getHeaders(), body: json.encode(category.toJson()));

    fetchAllCategories();
  }

  @override
  Future<void> deleteCategory({required Category category}) async {
    final url = Uri.http(baseURL, '/api/categories/${category.id}');

    final resp = await http.delete(url, headers: await _getHeaders());

    if (resp.statusCode != 200) {
      throw CategoryFailure(jsonDecode(resp.body)['message']);
    }

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
