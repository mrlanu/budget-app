import 'package:network/network.dart';

import '../../constants/api.dart';
import '../models/models.dart';

class DebtFailure implements Exception {
  final String message;

  const DebtFailure([
    this.message = 'An unknown exception occurred.',
  ]);
}

abstract class DebtsRepository {
  Future<List<Debt>> fetchAllDebts();

  Future<Debt> saveDebt({required Debt debt});

  Future<void> deleteDebt({required String debtId});
}

class DebtRepositoryImpl extends DebtsRepository {
  DebtRepositoryImpl({NetworkClient? networkClient})
      : _networkClient = networkClient ?? NetworkClient.instance;

  final NetworkClient _networkClient;

  @override
  Future<List<Debt>> fetchAllDebts() async {
    try {
      final response = await _networkClient.get<List<dynamic>>(
        baseURL + '/api/debts',
      );
      final result = List<Map<String, dynamic>>.from(response.data!)
          .map((jsonMap) => Debt.fromJson(jsonMap))
          .toList();
      return result;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<Debt> saveDebt({required Debt debt}) async {
    try {
      final response = await _networkClient.post<Map<String, dynamic>>(
          baseURL + '/api/debts',
          data: debt.toJson());
      final newDebt = Debt.fromJson(response.data!);
      return newDebt;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<void> deleteDebt({required String debtId}) async {
    try {
      await _networkClient.delete(
          baseURL + '/api/debts',
          queryParameters: {'debtId': debtId});
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }
}
