import 'dart:convert';

import 'package:budget_app/budgets/budgets.dart';
import 'package:budget_app/shared/models/transaction_interface.dart';
import 'package:budget_app/shared/shared.dart';
import 'package:budget_app/transactions/models/transaction.dart';
import 'package:budget_app/transactions/models/transaction_tile.dart';
import 'package:budget_app/transfer/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloudFirestore;
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../../constants/api.dart';

abstract class TransactionsRepository {
  void initTransactions();

  Stream<List<ITransaction>> get transactions;

  Stream<List<Transfer>> getTransfers();

  Future<void> saveTransaction(
      {required Transaction transaction,
      TransactionTile? editedTransaction,
      required Budget budget});

  Future<void> saveTransfer(
      {required Transfer transfer,
      required Budget budget,
      TransactionTile? editedTransaction});

  Future<void> fetchTransfers({
    required DateTime dateTime,
  });

  Future<Transaction> deleteTransaction(String transactionId);

  Future<Transfer> deleteTransfer(String transferId);
}

class TransactionsRepositoryImpl extends TransactionsRepository {
  final _transactionsStreamController =
      BehaviorSubject<List<ITransaction>>.seeded(const []);

  final _transfersStreamController =
      BehaviorSubject<List<Transfer>>.seeded(const []);

  final cloudFirestore.FirebaseFirestore _firebaseFirestore;

  TransactionsRepositoryImpl(
      {cloudFirestore.FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore =
            firebaseFirestore ?? cloudFirestore.FirebaseFirestore.instance {}

  void initTransactions() async =>
      (await _firebaseFirestore.budgetTransactions())
          .snapshots()
          .listen((event) {
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

  @override
  Stream<List<ITransaction>> get transactions =>
      _transactionsStreamController.asBroadcastStream();

  @override
  Stream<List<Transfer>> getTransfers() =>
      _transfersStreamController.asBroadcastStream();

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
    _firebaseFirestore.saveTransfer(transfer: transfer, budget: budget, editedTransfer: editedTransaction);
  }

  @override
  Future<void> fetchTransfers({
    required DateTime dateTime,
  }) async {
    final url = isTestMode
        ? Uri.http(baseURL, '/api/transfers',
            {'budgetId': await getBudgetId(), 'date': dateTime.toString()})
        : Uri.https(baseURL, '/api/transfers',
            {'budgetId': await getBudgetId(), 'date': dateTime.toString()});

    final response = await http.get(url, headers: await getHeaders());
    final result = List<Map<String, dynamic>>.from(
      json.decode(response.body) as List,
    ).map((jsonMap) => Transfer.fromJson(jsonMap)).toList();
    _transfersStreamController.add(result);
  }

  @override
  Future<Transaction> deleteTransaction(String transactionId) async {
    /*final url = isTestMode
        ? Uri.http(
            baseURL, '/api/transactions', {'transactionId': transactionId})
        : Uri.https(
            baseURL, '/api/transactions', {'transactionId': transactionId});
    final deletedTransactionResponse =
        await http.delete(url, headers: await getHeaders());
    final deletedTransaction =
        Transaction.fromJson(jsonDecode(deletedTransactionResponse.body));
    final transactions = [..._transactionsStreamController.value];
    final transactionIndex =
        transactions.indexWhere((t) => t.id == transactionId);
    if (transactionIndex == -1) {
      //throw TodoNotFoundException();
    } else {
      transactions.removeAt(transactionIndex);
      _transactionsStreamController.add(transactions);
    }
    return deletedTransaction;*/
    return Transaction();
  }

  @override
  Future<Transfer> deleteTransfer(String transferId) async {
    final url = isTestMode
        ? Uri.http(baseURL, '/api/transfers', {'transferId': transferId})
        : Uri.https(baseURL, '/api/transfers', {'transferId': transferId});
    final deletedTransferResponse =
        await http.delete(url, headers: await getHeaders());
    final deletedTransfer =
        Transfer.fromJson(jsonDecode(deletedTransferResponse.body));
    final transfers = [..._transfersStreamController.value];
    final transferIndex = transfers.indexWhere((t) => t.id == transferId);
    if (transferIndex == -1) {
      //throw TodoNotFoundException();
    } else {
      transfers.removeAt(transferIndex);
      _transfersStreamController.add(transfers);
    }
    return deletedTransfer;
  }
}
