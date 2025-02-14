import 'dart:async';

import 'package:budget_app/database/database.dart';
import 'package:budget_app/database/transaction_with_detail.dart';
import 'package:budget_app/transaction/repository/transaction_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../models/transaction_tile.dart';
import '../models/transaction_type.dart';

class TransactionRepositoryDrift extends TransactionRepository {
  TransactionRepositoryDrift({required AppDatabase database})
      : _database = database;

  final AppDatabase _database;
  final _transactionsStreamController =
      BehaviorSubject<List<TransactionWithDetails>>();

  @override
  Stream<List<TransactionWithDetails>> get transactions =>
      _transactionsStreamController.asBroadcastStream();

  @override
  void fetchTransactions(DateTime dateTime) async {
    List<TransactionWithDetails> transactions =
        await _database.getTransactionsForCertainMonth(dateTime);
    _transactionsStreamController.add(transactions);
    print('items in database: $transactions');
  }

  @override
  Future<void> createTransaction(Transaction transaction) async {
    await _database
        .into(_database.categories)
        .insert(CategoriesCompanion.insert(
          name: 'todo: finish drift setup',
          iconCode: 17,
          type: TransactionType.EXPENSE,
        ));
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
  }

  /*@override
  Future<void> updateTransfer(Transfer transfer) async {
    */ /*try {
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
    }*/ /*
  }*/

  @override
  Future<void> deleteTransactionOrTransfer(
      {required TransactionTile transaction}) async {
  }
}
