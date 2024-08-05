import 'dart:async';

import 'package:budget_app/utils/fast_hash.dart';
import 'package:cache/cache.dart';
import 'package:isar/isar.dart';
import 'package:network/network.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../../constants/api.dart';
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

  Future<void> saveTransaction(Transaction transaction);

  Future<void> deleteTransactionOrTransfer(
      {required ComprehensiveTransaction transaction});
}

class TransactionsRepositoryImpl extends TransactionsRepository {
  TransactionsRepositoryImpl({NetworkClient? networkClient})
      : _networkClient = networkClient ?? NetworkClient.instance;

  final NetworkClient _networkClient;
  final _transactionsStreamController = BehaviorSubject<List<Transaction>>();

  @override
  Stream<List<Transaction>> get transactions =>
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
  Future<void> saveTransaction(Transaction transaction) async {
    final transactions = [..._transactionsStreamController.value];
    if (transaction.id == null) {
      final response = await _networkClient.post<Map<String, dynamic>>(
          baseURL + '/api/transactions',
          data: transaction.toJson());
      final newTransaction = Transaction.fromJson(response.data!);
      transactions.add(newTransaction);
    } else{
      final response = await _networkClient.put<Map<String, dynamic>>(
          baseURL + '/api/transactions',
          data: transaction.toJson());
      final newTransaction = Transaction.fromJson(response.data!);
      final trIndex = transactions.indexWhere((t) => t.id == newTransaction.id);
      transactions.removeAt(trIndex);
      transactions.insert(trIndex, newTransaction);
    }
    _transactionsStreamController.add(transactions);

  }

  @override
  Future<void> deleteTransactionOrTransfer(
      {required ComprehensiveTransaction transaction}) async {
    try {
      await _networkClient
          .delete(baseURL + '/api/transactions/${transaction.id}');
      final transactions = [..._transactionsStreamController.value];
      final trIndex = transactions.indexWhere((t) => t.id == transaction.id);
      transactions.removeAt(trIndex);
      _transactionsStreamController.add(transactions);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }
}

class TransactionsRepositoryIsar extends TransactionsRepository {
  TransactionsRepositoryIsar({required this.isar});

  final Isar isar;
  final _transactionsStreamController = BehaviorSubject<List<Transaction>>();

  @override
  Stream<List<Transaction>> get transactions =>
      _transactionsStreamController.asBroadcastStream();

  @override
  Future<void> fetchTransactions(DateTime dateTime) async {
    // Get the first datetime of the given month
    DateTime firstDateTimeOfMonth = DateTime(dateTime.year, dateTime.month, 1);
    // Get the last datetime of the given month
    DateTime lastDayOfMonth = DateTime(dateTime.year, dateTime.month + 1, 0);
    DateTime lastDateTimeOfMonth = DateTime(dateTime.year, dateTime.month,
        lastDayOfMonth.day, 23, 59, 59, 999, 999);
    final trByDate = await isar.transactions
        .filter()
        .dateGreaterThan(firstDateTimeOfMonth)
        .and()
        .dateLessThan(lastDateTimeOfMonth)
        .build()
        .findAll();
    _transactionsStreamController.add(trByDate);
  }

  @override
  Future<void> saveTransaction(Transaction transaction) async {
    final transactions = [..._transactionsStreamController.value];
    if (transaction.id == null) {
      transaction = transaction.copyWith(id: Uuid().v4());
      transactions.add(transaction);
    } else{
      final trIndex = transactions.indexWhere((t) => t.id == transaction.id);
      transactions.removeAt(trIndex);
      transactions.insert(trIndex, transaction);
    }
    await isar.writeTxn(() async {
      await isar.transactions.put(transaction);
    });
    _transactionsStreamController.add(transactions);
  }

  @override
  Future<void> deleteTransactionOrTransfer(
      {required ComprehensiveTransaction transaction}) async {
    await isar.writeTxn(() async {
      await isar.transactions.delete(fastHash(transaction.id));
    });
    final transactions = [..._transactionsStreamController.value];
    final trIndex = transactions.indexWhere((t) => t.id == transaction.id);
    transactions.removeAt(trIndex);
    _transactionsStreamController.add(transactions);
  }

}
