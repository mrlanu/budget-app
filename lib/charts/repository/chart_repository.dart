import 'package:budget_app/charts/models/year_month_sum.dart';
import 'package:cache/cache.dart';
import 'package:network/network.dart';

import '../../constants/api.dart';

abstract class ChartRepository {
  Future<List<YearMonthSum>> fetchTrendChartData();

  Future<List<YearMonthSum>> fetchCategoryChartData(String categoryId);

  Future<List<YearMonthSum>> fetchSubcategoryChartData(String id);
}

class ChartRepositoryImpl extends ChartRepository {
  ChartRepositoryImpl({NetworkClient? networkClient})
      : _networkClient = networkClient ?? NetworkClient.instance;

  final NetworkClient _networkClient;

  @override
  Future<List<YearMonthSum>> fetchTrendChartData() async {
    try {
      final response = await _networkClient.get<List<dynamic>>(
          baseURL + '/api/charts/trend-chart',
          queryParameters: {'budgetId': await Cache.instance.getBudgetId()});
      final result = List<Map<String, dynamic>>.from(response.data!)
          .map((jsonMap) => YearMonthSum.fromJson(jsonMap))
          .toList();
      return result;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<List<YearMonthSum>> fetchCategoryChartData(String categoryId) async {
    try {
      final response = await _networkClient.get<List<dynamic>>(
          baseURL + '/api/charts/category-chart',
          queryParameters: {'categoryId': categoryId});
      final result = List<Map<String, dynamic>>.from(response.data!)
          .map((jsonMap) => YearMonthSum.fromJson(jsonMap))
          .toList();
      return result;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<List<YearMonthSum>> fetchSubcategoryChartData(String id) async {
    try {
      final response = await _networkClient.get<List<dynamic>>(
          baseURL + '/api/charts/subcategory-chart',
          queryParameters: {'categoryId': id});
      final result = List<Map<String, dynamic>>.from(response.data!)
          .map((jsonMap) => YearMonthSum.fromJson(jsonMap))
          .toList();
      return result;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }
}
