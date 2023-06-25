import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../../constants/api.dart';
import '../../shared/models/budget.dart';

abstract class BudgetRepository {
  Future<Budget> fetchBudget();
}

class BudgetRepositoryImpl extends BudgetRepository{

  @override
  Future<Budget> fetchBudget() async {
    final url = Uri.http(baseURL, '/api/budgets');

    final response = await http.get(url, headers: await _getHeaders());

    return _decodeBudget(response.body);
  }

  Budget _decodeBudget(String data) {
    final budgetMap = json.decode(data);

    return Budget(
      id: budgetMap['id'],
      userId: budgetMap['userId'],
    );
  }

  Future<Map<String, String>> _getHeaders() async {

    final currentUser = await FirebaseAuth.instance.currentUser;
    final token = await currentUser?.getIdToken();

    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
  }

}
