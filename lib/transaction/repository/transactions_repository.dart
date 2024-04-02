import 'dart:async';

import 'package:cache_client/cache_client.dart';
import 'package:network/network.dart';
import 'package:rxdart/rxdart.dart';

import '../../constants/api.dart';
import '../../transfer/models/transfer.dart';
import '../transaction.dart';

class TransactionFailure implements Exception {
  final String message;

  const TransactionFailure([
    this.message = 'An unknown exception occurred.',
  ]);
}

abstract class TransactionsRepository {
  Stream<List<Transaction>> get transactions;

  void fetchTransactions(DateTime dateTime);

  Future<void> createTransaction(Transaction transaction);

  Future<void> updateTransaction(Transaction transaction);

  Future<void> updateTransfer(Transfer transfer);

  Future<void> deleteTransactionOrTransfer(
      {required ComprehensiveTransaction transaction});
}

class TransactionsRepositoryImpl extends TransactionsRepository {
  TransactionsRepositoryImpl({NetworkClient? networkClient})
      : _networkClient = networkClient ?? NetworkClient.instance;

  final NetworkClient _networkClient;
  final _transactionsStreamController =
      BehaviorSubject<List<Transaction>>();

  @override
  Stream<List<Transaction>> get transactions =>
      _transactionsStreamController.asBroadcastStream();

  @override
  void fetchTransactions(DateTime dateTime) async {
    try {
      final response = await _networkClient
          .get<List<dynamic>>(baseURL + '/api/transactions', queryParameters: {
        'budgetId': await CacheClient.instance.getBudgetId(),
        'date': dateTime.toString()
      });
      final transactions = List<Map<String, dynamic>>.from(response.data!)
          .map((jsonMap) => Transaction.fromJson(jsonMap))
          .toList();
      _transactionsStreamController.add(transactions);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<void> createTransaction(Transaction transaction) async {
    try {
      final response = await _networkClient.post<Map<String, dynamic>>(
          baseURL + '/api/transactions',
          data: transaction.toJson());
      final newTransaction = Transaction.fromJson(response.data!);
      final transactions = [..._transactionsStreamController.value];
      transactions.add(newTransaction);
      _transactionsStreamController.add(transactions);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    try {
      final response = await _networkClient.put<Map<String, dynamic>>(
          baseURL + '/api/transactions',
          data: transaction.toJson());
      final updatedTransaction = Transaction.fromJson(response.data!);
      final transactions = [..._transactionsStreamController.value];
      final trIndex = transactions.indexWhere((t) => t.id == transaction.id);
      transactions.removeAt(trIndex);
      transactions.insert(trIndex, transaction);
      _transactionsStreamController.add(transactions);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<void> updateTransfer(Transfer transfer) async {

    try {
      final response = await _networkClient.put<Map<String, dynamic>>(
          baseURL + '/api/transfers',
          data: transfer.toJson());
      final updatedTransfer =
      Transfer.fromJson(response.data!);
      final transactions = [..._transactionsStreamController.value];
      final trIndex = transactions.indexWhere((t) => t.id == transfer.id);
      transactions.removeAt(trIndex);
      //transactions.insert(trIndex, transfer);
      _transactionsStreamController.add(transactions);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  @override
  Future<void> deleteTransactionOrTransfer(
      {required ComprehensiveTransaction transaction}) async {
    final partUrl = transaction.type == TransactionType.TRANSFER
        ? 'transfers'
        : 'transactions';

    try {
      final response = await _networkClient.delete(
          baseURL + '/api/$partUrl/${transaction.id}');
      final transactions = [..._transactionsStreamController.value];
      final trIndex = transactions.indexWhere((t) => t.id == transaction.id);
      transactions.removeAt(trIndex);
      _transactionsStreamController.add(transactions);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  Future<List<Transaction>> _fetchTransactions({
    required DateTime dateTime,
  }) async {
    try {
      final response = await _networkClient
          .get<List<dynamic>>(baseURL + '/api/transactions', queryParameters: {
        'budgetId': await CacheClient.instance.getBudgetId(),
        'date': dateTime.toString()
      });
      final result = List<Map<String, dynamic>>.from(response.data!)
          .map((jsonMap) => Transaction.fromJson(jsonMap))
          .toList();
      return result;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  Future<List<Transfer>> _fetchTransfers({
    required DateTime dateTime,
  }) async {
    try {
      final response = await _networkClient
          .get<List<dynamic>>(baseURL + '/api/transfers', queryParameters: {
        'budgetId': await CacheClient.instance.getBudgetId(),
        'date': dateTime.toString()
      });
      final result = List<Map<String, dynamic>>.from(response.data!)
          .map((jsonMap) => Transfer.fromJson(jsonMap))
          .toList();
      return result;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }
}
