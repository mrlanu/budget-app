import 'dart:convert';

import 'package:budget_app/shared/models/budget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

const bool isTestMode = false;

final baseURL = isTestMode
    ? kIsWeb
        ? 'localhost:8080'
        : '10.0.2.2:8080'
    : kIsWeb
        ? 'qruto-budget-app-bd7e344cca5d.herokuapp.com'
        : 'qruto-budget-app-bd7e344cca5d.herokuapp.com';

Future<Map<String, String>> getHeaders() async {
  final currentUser = await FirebaseAuth.instance.currentUser;
  final token = await currentUser?.getIdToken();

  return {"Content-Type": "application/json", "Authorization": "Bearer $token"};
}

Future<String> getBudgetId() async {
  final instance = await SharedPreferences.getInstance();
  final budgetJson = instance.getString('budget');
  Budget budget;
  if (budgetJson != null) {
    budget = Budget.fromJson(jsonDecode(budgetJson));
  } else {
    budget = Budget(id: '', userId: '');
  }
  return budget.id;
}
