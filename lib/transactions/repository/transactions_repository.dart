import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:budget_app/transactions/models/transaction.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

enum TransactionsFilter {
  category,
  account,
}

abstract class TransactionsRepository {
  final User user;

  const TransactionsRepository({required this.user});

  Stream<List<Transaction>> getTransactions();

  Future<void> createTransaction(Transaction transaction);

  Future<List<Transaction>> fetchAllTransactions({
    required String budgetId,
    required TransactionsFilter filterBy,
    required String filterId,
    required DateTime dateTime,
  });

  Future<Transaction> fetchTransactionById(String transactionId);

  Future<void> deleteTransaction(String transactionId);
}

class TransactionsRepositoryImpl extends TransactionsRepository {
  static const baseURL = '10.0.2.2:8080';

  final _transactionsStreamController =
      BehaviorSubject<List<Transaction>>.seeded(const []);

  TransactionsRepositoryImpl({required super.user});

  @override
  Stream<List<Transaction>> getTransactions() =>
      _transactionsStreamController.asBroadcastStream();

  @override
  Future<void> createTransaction(Transaction transaction) async {
    final url = Uri.http(baseURL, '/api/transactions');

    final tr = await http.post(url,
        headers: await _getHeaders(), body: json.encode(transaction.toJson()));
    final transactions = [..._transactionsStreamController.value];
    transactions.add(Transaction.fromJson(jsonDecode(tr.body)));
    _transactionsStreamController.add(transactions);
  }

  @override
  Future<List<Transaction>> fetchAllTransactions({
    required String budgetId,
    required TransactionsFilter filterBy,
    required String filterId,
    required DateTime dateTime,
  }) async {
    final url = switch (filterBy) {
      TransactionsFilter.account => Uri.http(baseURL, '/api/transactions', {
          'budgetId': budgetId,
          'categoryId': '',
          'accountId': filterId,
          'date': dateTime.toString()
        }),
      TransactionsFilter.category => Uri.http(baseURL, '/api/transactions', {
          'budgetId': budgetId,
          'categoryId': filterId,
          'accountId': '',
          'date': dateTime.toString()
        }),
    };

    final response = await http.get(url, headers: await _getHeaders());

    final result = List<Map<String, dynamic>>.from(
      json.decode(response.body) as List,
    )
        .map((jsonMap) =>
            Transaction.fromJson(Map<String, dynamic>.from(jsonMap)))
        .toList();

    _transactionsStreamController.add(result);
    return result;
  }

  @override
  Future<Transaction> fetchTransactionById(String transactionId) async {
    final url = Uri.http(baseURL, '/api/transactions/$transactionId');

    final response = await http.get(url, headers: await _getHeaders());

    final result = Transaction.fromJson(json.decode(response.body));

    return result;
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    final url = Uri.http(
        baseURL, '/api/transactions', {'transactionId': transactionId});
    await http.delete(url, headers: await _getHeaders());
    final transactions = [..._transactionsStreamController.value];
    final trIndex = transactions.indexWhere((t) => t.id == transactionId);

    transactions.removeAt(trIndex);
    _transactionsStreamController.add(transactions);
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await user.token;
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
  }
}
