import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:budget_app/transaction/models/transaction.dart';
import 'package:http/http.dart' as http;

abstract class TransactionsRepository {

  final User user;

  const TransactionsRepository({required this.user});

  Future<void> createTransaction(Transaction transaction);
}

class TransactionRepositoryImpl extends TransactionsRepository {

  static const baseURL = 'http://10.0.2.2:8080/api';

  TransactionRepositoryImpl({required super.user});

  @override
  Future<void> createTransaction(Transaction transaction) async {
    final url = '$baseURL/transactions';

    final token = await user.token;
    final response = await http.post(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    }, body: json.encode(transaction.toJson()));

    print('Trans: ${response.body}');

    /*final result = List<Map<dynamic, dynamic>>.from(
      json.decode(response.body) as List,
    )
        .map((jsonMap) =>
        CategorySummary.fromJson(Map<String, dynamic>.from(jsonMap)))
        .toList();

    return result;*/
  }

}
