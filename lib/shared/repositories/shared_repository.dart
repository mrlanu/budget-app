import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:budget_app/shared/models/summary_by.dart';
import 'package:http/http.dart' as http;

abstract class SharedRepository {
  final User user;

  SharedRepository({required this.user});

  Future<List<SummaryBy>> fetchSummaryList(
      {required String budgetId,
      required String section,
      required DateTime dateTime});

  Future<Map<String, double>> fetchAllSections(String budgetId, DateTime dateTime);
}

class SharedRepositoryImpl extends SharedRepository {
  SharedRepositoryImpl({required super.user});

  static const baseURL = 'http://10.0.2.2:8080/api';

  @override
  Future<List<SummaryBy>> fetchSummaryList(
      {required String budgetId,
      required String section,
      required DateTime dateTime}) async {
    final url =
        '$baseURL/$budgetId/summary?date=$dateTime&section=$section';

    final token = await user.token;
    final response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    final summaryByList = List<Map<String, dynamic>>.from(
      json.decode(response.body) as List,
    )
        .map((jsonMap) =>
        SummaryBy.fromJson(Map<String, dynamic>.from(jsonMap)))
        .toList();
    return summaryByList;
  }

  @override
  Future<Map<String, double>> fetchAllSections(String budgetId, DateTime dateTime) async {
    final url = '$baseURL/$budgetId/sections?date=$dateTime';

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
}
