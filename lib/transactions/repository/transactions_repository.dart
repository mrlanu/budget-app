import 'dart:async';

import 'package:budget_app/budgets/budgets.dart';
import 'package:budget_app/shared/models/transaction_interface.dart';
import 'package:budget_app/shared/shared.dart';
import 'package:budget_app/transactions/models/transaction.dart';
import 'package:budget_app/transactions/models/transaction_tile.dart';
import 'package:budget_app/transfer/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloudFirestore;
import 'package:rxdart/rxdart.dart';

abstract class TransactionsRepository {
  void initTransactions(DateTime dateTime);

  Stream<List<ITransaction>> get transactions;

  Future<void> saveTransaction(
      {required Transaction transaction,
      TransactionTile? editedTransaction,
      required Budget budget});

  Future<void> saveTransfer(
      {required Transfer transfer,
      required Budget budget,
      TransactionTile? editedTransaction});

  Future<Transaction> deleteTransactionOrTransfer(
      {required TransactionTile transaction, required Budget budget});
}

class TransactionsRepositoryImpl extends TransactionsRepository {
  final _transactionsStreamController =
      BehaviorSubject<List<ITransaction>>.seeded(const []);

  final cloudFirestore.FirebaseFirestore _firebaseFirestore;
  StreamSubscription<cloudFirestore.QuerySnapshot<Map<String, dynamic>>>?
      _fireSubscription;

  TransactionsRepositoryImpl(
      {cloudFirestore.FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore =
            firebaseFirestore ?? cloudFirestore.FirebaseFirestore.instance {}

  void initTransactions(DateTime dateTime) async {
    await _fireSubscription?.cancel();
    final snapshots =
        (await _firebaseFirestore.queryTransactionsByDate(dateTime))
            .snapshots();
    _fireSubscription = snapshots.listen((event) {
      final transactions = event.docs.map(
        (e) {
          if (e.data()['type'] != null) {
            return Transaction.fromFirestore(e);
          } else {
            return Transfer.fromFirestore(e);
          }
        },
      ).toList();
      _transactionsStreamController.add(transactions);
    });
  }

  @override
  Stream<List<ITransaction>> get transactions =>
      _transactionsStreamController.asBroadcastStream();

  @override
  Future<void> saveTransaction(
          {required Transaction transaction,
          TransactionTile? editedTransaction,
          required Budget budget}) async =>
      _firebaseFirestore.saveTransaction(
          transaction: transaction,
          editedTransaction: editedTransaction,
          budget: budget);

  @override
  Future<void> saveTransfer(
      {required Transfer transfer,
      required Budget budget,
      TransactionTile? editedTransaction}) async {
    _firebaseFirestore.saveTransfer(
        transfer: transfer, budget: budget, editedTransfer: editedTransaction);
  }

  @override
  Future<Transaction> deleteTransactionOrTransfer(
      {required TransactionTile transaction, required Budget budget}) async {
    _firebaseFirestore.deleteTransaction(
        transaction: transaction, budget: budget);
    return Transaction();
  }
}
