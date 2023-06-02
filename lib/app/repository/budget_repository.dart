import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../shared/models/budget.dart';

abstract class BudgetRepository {
  Future<Budget> fetchBudget(String token);
}

class BudgetRepositoryImpl extends BudgetRepository{

  static const baseURL = 'http://10.0.2.2:8080/api/budgets';

  @override
  Future<Budget> fetchBudget(String token) async {
    final url = '$baseURL';

    final response = await http.get(Uri.parse(url), headers: {
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
