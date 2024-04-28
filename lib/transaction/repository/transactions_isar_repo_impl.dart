import 'package:budget_app/transaction/models/comprehensive_transaction.dart';
import 'package:budget_app/transaction/models/transaction.dart';
import 'package:budget_app/transaction/repository/transactions_repository.dart';
import 'package:budget_app/transfer/models/transfer.dart';
import 'package:isar/isar.dart';
import 'package:rxdart/rxdart.dart';

class TransactionRepoIsarImpl implements TransactionsRepository {
  TransactionRepoIsarImpl({required this.isar});

  final Isar isar;
  final _transactionsStreamController = BehaviorSubject<List<Transaction>>();

  @override
  Stream<List<Transaction>> get transactions =>
      _transactionsStreamController.asBroadcastStream();

  @override
  Future<void> createTransaction(Transaction transaction) async {
    await isar.writeTxn(() async {
      await isar.transactions.put(transaction); // insert & update
    });
    final transactions = [..._transactionsStreamController.value];
    transactions.add(transaction);
    _transactionsStreamController.add(transactions);
  }

  @override
  Future<void> deleteTransactionOrTransfer(
      {required ComprehensiveTransaction transaction}) {
    // TODO: implement deleteTransactionOrTransfer
    throw UnimplementedError();
  }

  @override
  void fetchTransactions(DateTime dateTime) async {
    final trs = await isar.transactions.where().findAll();
    final transactions = trs.map((t) => Transaction(
        budgetId: t.budgetId,
        date: t.date,
        amount: t.amount,
        fromAccountId: t.fromAccountId,
        toAccountId: t.toAccountId,
        id: t.id,
        description: t.description,
        subcategoryId: t.subcategoryId,
        categoryId: t.categoryId,
        type: t.type)).toList();
    _transactionsStreamController.add(transactions);
  }

  @override
  Future<void> updateTransaction(Transaction transaction) {
    // TODO: implement updateTransaction
    throw UnimplementedError();
  }

  @override
  Future<void> updateTransfer(Transfer transfer) {
    // TODO: implement updateTransfer
    throw UnimplementedError();
  }
}
