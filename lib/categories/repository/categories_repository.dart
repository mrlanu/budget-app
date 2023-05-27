
import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../shared/models/category.dart';
import '../../shared/models/section.dart';
import '../../transactions/models/transaction_type.dart';
import 'package:http/http.dart' as http;

abstract class CategoriesRepository {

  final User user;

  const CategoriesRepository({required this.user});

  Stream<List<Category>> getCategories();
  Future<List<Category>> fetchCategories(
      {required String budgetId, required TransactionType transactionType});
  Future<void> saveCategory({required String budgetId, required Category category});
}

class CategoriesRepositoryImpl extends CategoriesRepository {

  static const baseURL = 'http://10.0.2.2:8080/api';

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
    final url = '$baseURL/$budgetId/categories';

    final response = await http.get(Uri.parse(url), headers: await _getHeaders());

    final section = switch (transactionType) {
    TransactionType.INCOME => Section.INCOME,
    TransactionType.EXPENSE => Section.EXPENSES,
    TransactionType.TRANSFER => Section.ACCOUNTS,
    };

    final result = List<Map<String, dynamic>>.from(
    json.decode(response.body) as List,
    )
        .map((jsonMap) => Category.fromJson(Map<String, dynamic>.from(jsonMap)))
        .where((cat) => cat.section == section)
        .toList();

    _categoriesStreamController.add(result);

    return result;
  }

  @override
  Future<void> saveCategory({required String budgetId, required Category category}) async {
    final url = '$baseURL/$budgetId/category';

    final response = await http.post(Uri.parse(url),
        headers: await _getHeaders(),
        body: json.encode(category.toJson()));

    final newCategory = Category.fromJson(jsonDecode(response.body));
    final categories = [..._categoriesStreamController.value];
    categories.add(newCategory);
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
