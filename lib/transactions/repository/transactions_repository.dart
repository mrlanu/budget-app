import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:budget_app/transactions/models/transaction.dart';
import 'package:http/http.dart' as http;

abstract class TransactionsRepository {

  final User user;

  const TransactionsRepository({required this.user});

  Future<void> createTransaction(Transaction transaction);
  Future<List<Transaction>> fetchAllTransaction(String budgetId);
}

class TransactionRepositoryImpl extends TransactionsRepository {

  static const baseURL = 'http://10.0.2.2:8080/api';

  TransactionRepositoryImpl({required super.user});

  @override
  Future<void> createTransaction(Transaction transaction) async {
    final url = '$baseURL/transactions';

    final token = await user.token;
    await http.post(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    }, body: json.encode(transaction.toJson()));
  }

  @override
  Future<List<Transaction>> fetchAllTransaction(String budgetId) async {
    final url = '$baseURL/transactions?budgetId=$budgetId,date=${DateTime.now()}';

    final token = await user.token;
    final response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    print('Transactions: ${response.body}');
    return [];
  }



}
