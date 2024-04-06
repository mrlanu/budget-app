import 'package:flutter/foundation.dart' show kIsWeb;

const bool isTestMode = false;

final baseURL = isTestMode
    ? kIsWeb
        ? 'http://localhost:8080'
        : 'http://10.0.2.2:8080'
    : kIsWeb
        ? 'https://qruto-budget-app-bd7e344cca5d.herokuapp.com'
        : 'https://qruto-budget-app-bd7e344cca5d.herokuapp.com';

/*Future<Map<String, String>> getHeaders() async {
  final instance = await SharedPreferences.getInstance();
  final token = instance.getString('token') ?? '';
  return {"Content-Type": "application/json", "Authorization": "Bearer $token"};
}

Future<String> getUserId() async {
  final instance = await SharedPreferences.getInstance();
  return instance.getString('userId') ?? '';
}

Future<String> getCurrentBudgetId() async {
  final instance = await SharedPreferences.getInstance();
  return instance.getString('currentBudgetId') ?? '';
}*/

/*Future<String> getBudgetId() async {
  final instance = await SharedPreferences.getInstance();
  final budgetJson = instance.getString('budget');
  Budget budget;
  if (budgetJson != null) {
    budget = Budget.fromJson(jsonDecode(budgetJson));
  } else {
    budget = Budget();
  }
  return budget.id;
}*/
