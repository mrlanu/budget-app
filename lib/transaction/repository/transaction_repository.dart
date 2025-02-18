import 'dart:async';

import 'package:budget_app/database/transaction_with_detail.dart';

import '../models/transaction_type.dart';

class TransactionFailure implements Exception {
  final String message;

  const TransactionFailure([
    this.message = 'An unknown exception occurred.',
  ]);
}

abstract class TransactionRepository {
  Stream<List<TransactionWithDetails>> get transactions;

  void fetchTransactions(DateTime dateTime);

  Future<TransactionWithDetails> getTransactionById(int transactionId);

  Future<int> insertTransaction(
      {required DateTime date,
      required TransactionType type,
      required double amount,
      int? categoryId,
      int? subcategoryId,
      required int fromAccountId,
      int? toAccountId,
      required String description});

  Future<void> updateTransaction(
      {required int id,
      required DateTime date,
      required TransactionType type,
      required double amount,
      int? categoryId,
      int? subcategoryId,
      required int fromAccountId,
      int? toAccountId,
      required String description});

  Future<void> deleteTransactionOrTransfer(
      {required int transactionId});
}

/*class TransactionsRepositoryImpl extends TransactionRepository {
  TransactionsRepositoryImpl({NetworkClient? networkClient})
      : _networkClient = networkClient ?? NetworkClient.instance;

  final NetworkClient _networkClient;
  final _transactionsStreamController =
      BehaviorSubject<List<TransactionWithDetails>>();

  @override
  Stream<List<TransactionWithDetails>> get transactions =>
      _transactionsStreamController.asBroadcastStream();

  @override
  void fetchTransactions(DateTime dateTime) async {
    try {
      final response = await _networkClient
          .get<List<dynamic>>(baseURL + '/api/transactions', queryParameters: {
        'budgetId': await Cache.instance.getBudgetId(),
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

  */ /*@override
  Future<void> updateTransfer(Transfer transfer) async {

    try {
      final response = await _networkClient.put<Map<String, dynamic>>(
          baseURL + '/api/transactions',
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
  }*/ /*

  @override
  Future<void> deleteTransactionOrTransfer(
      {required TransactionTile transaction}) async {
    try {
      final response = await _networkClient.delete(
          baseURL + '/api/transactions/${transaction.id}');
      final transactions = [..._transactionsStreamController.value];
      final trIndex = transactions.indexWhere((t) => t.id == transaction.id);
      transactions.removeAt(trIndex);
      _transactionsStreamController.add(transactions);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }
}*/
