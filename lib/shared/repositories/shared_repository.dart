import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../../accounts/models/account_brief.dart';
import '../../categories/models/category.dart';
import '../../categories/models/category_summary.dart';
import '../../categories/models/subcategory.dart';
import '../models/budget.dart';

abstract class SharedRepository {
  final User user;

  Stream<List<CategorySummary>> getCategorySummary();

  SharedRepository({required this.user});

  Future<Budget> fetchBudget();

  Future<Map<String, double>> fetchAllSections(String budgetId);

  Future<List<CategorySummary>> fetchSummaryByCategory(
      {required String budgetId, required String section});
}

class SharedRepositoryImpl extends SharedRepository {
  SharedRepositoryImpl({required super.user});

  static const baseURL = 'http://10.0.2.2:8080/api';

  final _categorySummaryStreamController =
      BehaviorSubject<List<CategorySummary>>.seeded(const []);

  Future<Budget> fetchBudget() async {
    final url = '$baseURL/budgets';

    final token = await user.token;
    final response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    final budgetMap = json.decode(response.body);
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

    final budget = Budget(
      id: budgetMap['id'],
      userId: budgetMap['userId'],
      categoryList: categoryList,
      subcategoryList: subcategoryList,
      accountBriefList: accountList,
    );

    return budget;
  }

  @override
  Future<Map<String, double>> fetchAllSections(String budgetId) async {
    final url = '$baseURL/budgets/sections?budgetId=$budgetId';

    final token = await user.token;
    final response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });
    final decodedResponse = jsonDecode(response.body);
    final Map<String, double> result = {
      'EXPENSES': decodedResponse['EXPENSES'],
      'INCOME': decodedResponse['INCOME'],
      'ACCOUNTS': decodedResponse['ACCOUNTS']
    };
    return result;
  }

  @override
  Stream<List<CategorySummary>> getCategorySummary() =>
      _categorySummaryStreamController.asBroadcastStream();

  @override
  Future<List<CategorySummary>> fetchSummaryByCategory(
      {required String budgetId, required String section}) async {
    final url =
        '$baseURL/budgets/categories?budgetId=$budgetId&section=$section';

    final token = await user.token;
    final response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    final result = List<Map<dynamic, dynamic>>.from(
      json.decode(response.body) as List,
    )
        .map((jsonMap) =>
            CategorySummary.fromJson(Map<String, dynamic>.from(jsonMap)))
        .toList();

    print('Result: $result');
    _categorySummaryStreamController.add(result);
    return result;
  }
}
