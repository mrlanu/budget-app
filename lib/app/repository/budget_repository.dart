import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/api.dart';
import '../../shared/models/budget.dart';

abstract class BudgetRepository {
  Future<void> fetchBudget();
}

class BudgetRepositoryImpl extends BudgetRepository{

  final SharedPreferences _plugin;

  BudgetRepositoryImpl({required SharedPreferences plugin}): _plugin = plugin;

  @override
  Future<void> fetchBudget() async {
    final url = Uri.http(baseURL, '/api/budgets');

    final response = await http.get(url, headers: await getHeaders());
    await _setValue('budget', response.body);
  }

  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);
}
