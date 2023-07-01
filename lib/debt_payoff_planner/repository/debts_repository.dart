import 'dart:convert';

import '../../constants/api.dart';
import '../models/models.dart';
import 'package:http/http.dart' as http;

class DebtFailure implements Exception {
  final String message;

  const DebtFailure([
    this.message = 'An unknown exception occurred.',
  ]);
}

abstract class DebtsRepository {
  Future<List<Debt>> fetchAllDebts();
  Future<Debt> saveDebt({required Debt debt});
  Future<Debt> editDebt({required Debt debt});
  Future<Debt> deleteDebt({required String debtId});
}

class DebtRepositoryImpl extends DebtsRepository {
  @override
  Future<Debt> deleteDebt({required String debtId}) {
    throw UnimplementedError();
  }

  @override
  Future<Debt> editDebt({required Debt debt}) {
    throw UnimplementedError();
  }

  @override
  Future<List<Debt>> fetchAllDebts() async {
    final url = Uri.http(baseURL, '/api/debts', {'budgetId': await getBudgetId()});

    final response = await http.get(url, headers: await getHeaders());
    final result = List<Map<String, dynamic>>.from(
      json.decode(response.body) as List,
    ).map((jsonMap) => Debt.fromJson(jsonMap)).toList();
    print('Debts: $result');
    return result;
  }

  @override
  Future<Debt> saveDebt({required Debt debt}) async {
    final url = Uri.http(baseURL, '/api/debts');
    final debtResponse = await http.post(url,
        headers: await getHeaders(), body: json.encode(debt.toJson()));
    if(debtResponse.statusCode != 200){
      throw DebtFailure(jsonDecode(debtResponse.body)['message']);
    }
    final newDebt = Debt.fromJson(jsonDecode(debtResponse.body));
    return newDebt;
  }

}
