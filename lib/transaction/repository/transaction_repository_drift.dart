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
  //stream for date range transactions
  late Stream<List<TransactionWithDetails>>? _transactionsStream;
  StreamSubscription<List<TransactionWithDetails>>?
      _transactionsStreamSubscription;

  @override
  Stream<List<TransactionWithDetails>> get transactions =>
      _transactionsStreamController.asBroadcastStream();

  @override
  Future<TransactionWithDetails> getTransactionById(int transactionId) =>
      _database.getTransactionWithDetailsById(transactionId);

  @override
  void fetchTransactions(DateTime dateTime) async {
    _transactionsStreamSubscription?.cancel();
    _transactionsStream = _database.getTransactionsForCertainMonth(dateTime);
    _transactionsStreamSubscription = _transactionsStream?.listen(
      (event) => _transactionsStreamController.add(event),
    );
  }

  @override
  Future<int> insertTransaction(
          {required DateTime date,
          required TransactionType type,
          required double amount,
          required int categoryId,
          required int subcategoryId,
          required int fromAccountId,
          required String description}) =>
      _database.insertTransaction(TransactionsCompanion.insert(
          amount: amount,
          date: date,
          categoryId: categoryId,
          subcategoryId: subcategoryId,
          fromAccountId: fromAccountId,
          description: description,
          type: type));

  @override
  Future<void> updateTransaction(
          {required int id,
          required DateTime date,
          required TransactionType type,
          required double amount,
          required int categoryId,
          required int subcategoryId,
          required int fromAccountId,
          required String description}) =>
      _database.updateTransaction(Transaction(
          id: id,
          amount: amount,
          date: date,
          categoryId: categoryId,
          subcategoryId: subcategoryId,
          fromAccountId: fromAccountId,
          description: description,
          type: type));

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
    final transactions = [..._transactionsStreamController.value];
    final trIndex = transactions.indexWhere((t) => t.id == transaction.id);
    transactions.removeAt(trIndex);
    _transactionsStreamController.add(transactions);
    _database.deleteTransaction(transaction.id);
  }
}
