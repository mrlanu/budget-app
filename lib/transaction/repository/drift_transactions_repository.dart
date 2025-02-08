import 'dart:async';

import 'package:budget_app/database/database.dart';
import 'package:rxdart/rxdart.dart';

import '../../transfer/models/transfer.dart';
import '../transaction.dart' as tr;

class DriftTransactionsRepository extends tr.TransactionsRepository {
  DriftTransactionsRepository({AppDatabase? database})
      : _database = database ?? AppDatabase();

  final AppDatabase _database;
  final _transactionsStreamController = BehaviorSubject<List<tr.Transaction>>();

  @override
  Stream<List<tr.Transaction>> get transactions =>
      _transactionsStreamController.asBroadcastStream();

  @override
  void fetchTransactions(DateTime dateTime) async {
    List<Category> allItems =
        await _database.select(_database.categories).get();

    print('items in database: $allItems');
    /*try {
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
    }*/
  }

  @override
  Future<void> createTransaction(tr.Transaction transaction) async {
    await _database
        .into(_database.categories)
        .insert(CategoriesCompanion.insert(
          name: 'todo: finish drift setup',
          iconCode: 17,
          type: tr.TransactionType.EXPENSE,
        ));
    /*try {
      final response = await _networkClient.post<Map<String, dynamic>>(
          baseURL + '/api/transactions',
          data: transaction.toJson());
      final newTransaction = Transaction.fromJson(response.data!);
      final transactions = [..._transactionsStreamController.value];
      transactions.add(newTransaction);
      _transactionsStreamController.add(transactions);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }*/
  }

  @override
  Future<void> updateTransaction(tr.Transaction transaction) async {
    /*try {
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
    }*/
  }

  @override
  Future<void> updateTransfer(Transfer transfer) async {
    /*try {
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
    }*/
  }

  @override
  Future<void> deleteTransactionOrTransfer(
      {required tr.ComprehensiveTransaction transaction}) async {
    /*try {
      final response = await _networkClient.delete(
          baseURL + '/api/transactions/${transaction.id}');
      final transactions = [..._transactionsStreamController.value];
      final trIndex = transactions.indexWhere((t) => t.id == transaction.id);
      transactions.removeAt(trIndex);
      _transactionsStreamController.add(transactions);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }*/
  }
}
