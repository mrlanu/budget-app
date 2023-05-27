import 'dart:convert';

import '../../accounts/models/account_brief.dart';
import '../../shared/models/budget.dart';
import 'package:http/http.dart' as http;

import '../../shared/models/category.dart';
import '../../shared/models/subcategory.dart';

abstract class BudgetRepository {
  Future<Budget> fetchBudget(String token);
}

class BudgetRepositoryImpl extends BudgetRepository{

  static const baseURL = 'http://10.0.2.2:8080/api';

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
    final categoryList = List<Map<dynamic, dynamic>>.from(
        budgetMap['categoryList'])
        .map((jsonMap) => Category.fromJson(Map<String, dynamic>.from(jsonMap)))
        .toList();

    final subcategoryList =
    List<Map<dynamic, dynamic>>.from(budgetMap['subcategoryList'])
        .map((jsonMap) =>
        Subcategory.fromJson(Map<String, dynamic>.from(jsonMap)))
        .toList();

    final accountList =
    List<Map<dynamic, dynamic>>.from(budgetMap['accountBriefList'])
        .map((jsonMap) =>
        AccountBrief.fromJson(Map<String, dynamic>.from(jsonMap)))
        .toList();

    return Budget(
      id: budgetMap['id'],
      userId: budgetMap['userId'],
      categoryList: categoryList,
      subcategoryList: subcategoryList,
      accountBriefList: accountList,
    );
  }

}
