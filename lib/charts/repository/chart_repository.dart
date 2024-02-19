import 'dart:convert';

import 'package:budget_app/charts/models/year_month_sum.dart';
import 'package:http/http.dart' as http;

import '../../constants/api.dart';

abstract class ChartRepository {
  Future<List<YearMonthSum>> fetchTrendChartData();
  Future<List<YearMonthSum>> fetchCategoryChartData(String categoryId);
}

class ChartRepositoryImpl extends ChartRepository {
  @override
  Future<List<YearMonthSum>> fetchTrendChartData() async {
    final url = isTestMode
        ? Uri.http(baseURL, '/api/charts/trend-chart',
            {'budgetId': await getCurrentBudgetId()})
        : Uri.https(baseURL, '/api/charts/trend-chart',
            {'budgetId': await getCurrentBudgetId()});

    final response = await http.get(url, headers: await getHeaders());
    final result = List<Map<String, dynamic>>.from(
      json.decode(response.body) as List,
    ).map((jsonMap) => YearMonthSum.fromJson(jsonMap)).toList();
    return result;
  }

  @override
  Future<List<YearMonthSum>> fetchCategoryChartData(String categoryId) async {
    final url = isTestMode
        ? Uri.http(baseURL, '/api/charts/category-chart',
        {'categoryId': categoryId})
        : Uri.https(baseURL, '/api/charts/category-chart',
        {'categoryId': categoryId});

    final response = await http.get(url, headers: await getHeaders());
    final result = List<Map<String, dynamic>>.from(
      json.decode(response.body) as List,
    ).map((jsonMap) => YearMonthSum.fromJson(jsonMap)).toList();
    return result;
  }
}
