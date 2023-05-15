import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:budget_app/shared/models/section.dart';
import 'package:http/http.dart' as http;

import '../../accounts/models/account_brief.dart';
import '../models/budget.dart';
import '../models/category.dart';
import '../models/category_summary.dart';
import '../models/section_category_summary.dart';
import '../models/subcategory.dart';

abstract class SharedRepository {
  final User user;

  SharedRepository({required this.user});

  Future<Budget> fetchBudget();

  Future<SectionCategorySummary> fetchSectionCategorySummary(
      String budgetId, String section, DateTime date);
}

class SharedRepositoryImpl extends SharedRepository {
  SharedRepositoryImpl({required super.user});

  static const baseURL = 'http://10.0.2.2:8080/api';

  Future<Budget> fetchBudget() async {
    final url = '$baseURL/budgets';

    final token = await user.token;
    final response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    return _decodeBudget(response.body);
  }

  Budget _decodeBudget(String data){
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

  @override
  Future<SectionCategorySummary> fetchSectionCategorySummary(
      String budgetId, String section, DateTime date) async {
    final url = '$baseURL/budgets/$budgetId/summary?date=$date&section=$section';

    final token = await user.token;
    final response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    return _decodeSectionCategorySummary(response.body);
  }

  SectionCategorySummary _decodeSectionCategorySummary(String data){
    final decodedResponse = json.decode(data);

    final Map<Section, double> sectionMap = {
      Section.EXPENSES: decodedResponse['sectionMap']['EXPENSES'],
      Section.INCOME: decodedResponse['sectionMap']['INCOME'],
      Section.ACCOUNTS: decodedResponse['sectionMap']['ACCOUNTS']
    };

    final categorySummaryList = List<Map<dynamic, dynamic>>.from(
      decodedResponse['categorySummaryList'] as List,
    )
        .map((jsonMap) =>
        CategorySummary.fromJson(Map<String, dynamic>.from(jsonMap)))
        .toList();

    return SectionCategorySummary(
        sectionMap: sectionMap, categorySummaryList: categorySummaryList);
  }
}
