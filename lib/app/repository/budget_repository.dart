import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../constants/api.dart';
import '../../shared/models/budget.dart';

abstract class BudgetRepository {
  Future<Budget> fetchBudget(String token);
}

class BudgetRepositoryImpl extends BudgetRepository{

  @override
  Future<Budget> fetchBudget(String token) async {
    final url = Uri.http(baseURL, '/api/budgets');

    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    return _decodeBudget(response.body);
  }

  Budget _decodeBudget(String data) {
    final budgetMap = json.decode(data);

    return Budget(
      id: budgetMap['id'],
      userId: budgetMap['userId'],
    );
  }

}
