import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:budget_app/transactions/models/transaction.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../../shared/models/category.dart';
import '../../shared/models/section.dart';
import '../../shared/models/subcategory.dart';

abstract class TransactionsRepository {
  final User user;

  const TransactionsRepository({required this.user});

  Stream<List<Transaction>> getTransactions();
  Stream<List<Category>> getCategories();
  Stream<List<Subcategory>> getSubcategories();
  Future<void> createTransaction(Transaction transaction);
  Future<List<Transaction>> fetchAllTransactions(
      {required String budgetId,
      required DateTime dateTime,
      required String categoryId});
  Future<Transaction> fetchTransactionById(String transactionId);
  Future<List<Category>> fetchCategories(
      {required String budgetId, required TransactionType transactionType});
  Future<void> saveCategory({required String budgetId, required Category category});
  Future<void> saveSubcategory({required String budgetId, required Subcategory subcategory});
  Future<List<Subcategory>> fetchSubcategories(
      {required String budgetId,
        required String categoryId});
}

class TransactionsRepositoryImpl extends TransactionsRepository {
  final _transactionsStreamController =
      BehaviorSubject<List<Transaction>>.seeded(const []);
  final _categoriesStreamController =
      BehaviorSubject<List<Category>>.seeded(const []);
  final _subcategoriesStreamController =
  BehaviorSubject<List<Subcategory>>.seeded(const []);
  static const baseURL = 'http://10.0.2.2:8080/api';

  TransactionsRepositoryImpl({required super.user});

  @override
  Stream<List<Transaction>> getTransactions() =>
      _transactionsStreamController.asBroadcastStream();

  @override
  Stream<List<Category>> getCategories() =>
      _categoriesStreamController.asBroadcastStream();

  @override
  Stream<List<Subcategory>> getSubcategories() =>
      _subcategoriesStreamController.asBroadcastStream();

  @override
  Future<void> createTransaction(Transaction transaction) async {
    final url = '$baseURL/transactions';

    final token = await user.token;
    await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode(transaction.toJson()));
    _transactionsStreamController.add([]);
  }

  @override
  Future<List<Transaction>> fetchAllTransactions(
      {required String budgetId,
      required DateTime dateTime,
      required String categoryId}) async {
    final url =
        '$baseURL/transactions?budgetId=$budgetId&categoryId=$categoryId&date=${dateTime}';

    final token = await user.token;
    final response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    final result = List<Map<String, dynamic>>.from(
      json.decode(response.body) as List,
    )
        .map((jsonMap) =>
            Transaction.fromJson(Map<String, dynamic>.from(jsonMap)))
        .toList();

    return result;
  }

  @override
  Future<Transaction> fetchTransactionById(String transactionId) async {
    final url = '$baseURL/transactions/$transactionId';

    final token = await user.token;
    final response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    final result = Transaction.fromJson(json.decode(response.body));

    return result;
  }

  @override
  Future<List<Category>> fetchCategories(
      {required String budgetId,
      required TransactionType transactionType}) async {
    final url = '$baseURL/$budgetId/categories';
    final token = await user.token;
    final response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

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

    final token = await user.token;
    final response = await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode(category.toJson()));

    final newCategory = Category.fromJson(jsonDecode(response.body));
    final categories = [..._categoriesStreamController.value];
    categories.add(newCategory);
    _categoriesStreamController.add(categories);
  }

  @override
  Future<void> saveSubcategory({required String budgetId, required Subcategory subcategory}) async {
    final url = '$baseURL/$budgetId/subcategory';

    final token = await user.token;
    final response = await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
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
    final token = await user.token;
    final response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    final result = List<Map<String, dynamic>>.from(
    json.decode(response.body) as List,
    )
        .map((jsonMap) => Subcategory.fromJson(Map<String, dynamic>.from(jsonMap)))
        .where((scat) => scat.categoryId == categoryId)
        .toList();

    _subcategoriesStreamController.add(result);

    return result;
  }
}
