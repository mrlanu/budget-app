import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:budget_app/transactions/models/transaction.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

abstract class TransactionsRepository {

  final User user;

  const TransactionsRepository({required this.user});

  Stream<List<Transaction>> getTransactions();
  Future<void> createTransaction(Transaction transaction);
  Future<List<Transaction>> fetchAllTransactions(
      {required String budgetId,
      required DateTime dateTime,
      required String categoryId});
  Future<Transaction> fetchTransactionById(String transactionId);
}

class TransactionsRepositoryImpl extends TransactionsRepository {

  static const baseURL = 'http://10.0.2.2:8080/api';

  final _transactionsStreamController =
      BehaviorSubject<List<Transaction>>.seeded(const []);

  TransactionsRepositoryImpl({required super.user});

  @override
  Stream<List<Transaction>> getTransactions() =>
      _transactionsStreamController.asBroadcastStream();

  @override
  Future<void> createTransaction(Transaction transaction) async {
    final url = '$baseURL/transactions';

    await http.post(Uri.parse(url),
        headers: await _getHeaders(),
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

    final response = await http.get(Uri.parse(url), headers: await _getHeaders());

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

    final response = await http.get(Uri.parse(url), headers: await _getHeaders());

    final result = Transaction.fromJson(json.decode(response.body));

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
