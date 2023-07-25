import 'dart:convert';

import 'package:budget_app/charts/models/year_month_sum.dart';

import '../../constants/api.dart';
import 'package:http/http.dart' as http;

abstract class ChartRepository {
  Future<List<YearMonthSum>> fetchChart();
}

class ChartRepositoryImpl extends ChartRepository {
  @override
  Future<List<YearMonthSum>> fetchChart() async {
    final url = Uri.https(
        baseURL,
        '/api/charts/trend-chart',
        {'budgetId': await getBudgetId()});

    final response = await http.get(url, headers: await getHeaders());
    final result = List<Map<String, dynamic>>.from(
      json.decode(response.body) as List,
    ).map((jsonMap) => YearMonthSum.fromJson(jsonMap)).toList();
    return result;
  }
}
