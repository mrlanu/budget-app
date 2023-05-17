import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:budget_app/transactions/models/transaction.dart';
import 'package:budget_app/transactions/models/transaction_view.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

abstract class TransactionsRepository {
  final User user;

  const TransactionsRepository({required this.user});

  Stream<List<TransactionView>> getTransactions();
  Future<void> createTransaction(Transaction transaction);
  Future<List<TransactionView>> fetchAllTransactionView(
  {required String budgetId, required DateTime dateTime, required String categoryId});
}

class TransactionsRepositoryImpl extends TransactionsRepository {

  final _transactionsStreamController = BehaviorSubject<List<TransactionView>>.seeded(const []);
  static const baseURL = 'http://10.0.2.2:8080/api';

  TransactionsRepositoryImpl({required super.user});

  @override
  Stream<List<TransactionView>> getTransactions() => _transactionsStreamController.asBroadcastStream();

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
  Future<List<TransactionView>> fetchAllTransactionView(
  {required String budgetId, required DateTime dateTime, required String categoryId}) async {
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
        TransactionView.fromJson(Map<String, dynamic>.from(jsonMap)))
        .toList();

    return result;
  }
}
