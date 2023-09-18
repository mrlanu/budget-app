import 'dart:convert';

import 'package:budget_app/transactions/models/transaction.dart';
import 'package:budget_app/transfer/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloudFirestore;
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../../constants/api.dart';

abstract class TransactionsRepository {

  void initTransactions();

  Stream<List<Transaction>> get transactions;

  Stream<List<Transfer>> getTransfers();

  Future<void> createTransaction(Transaction transaction);

  Future<void> createTransfer(Transfer transfer);

  Future<void> editTransfer(Transfer transfer);

  Future<void> fetchTransfers({
    required DateTime dateTime,
  });

  Future<Transaction> deleteTransaction(String transactionId);

  Future<Transfer> deleteTransfer(String transferId);
}

class TransactionsRepositoryImpl extends TransactionsRepository {
  final _transactionsStreamController =
      BehaviorSubject<List<Transaction>>.seeded(const []);

  final _transfersStreamController =
      BehaviorSubject<List<Transfer>>.seeded(const []);

  final cloudFirestore.FirebaseFirestore _firebaseFirestore;

  TransactionsRepositoryImpl(
      {cloudFirestore.FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore =
            firebaseFirestore ?? cloudFirestore.FirebaseFirestore.instance {}

  void initTransactions() async {
    final userId = await getUserId();
    final budgetId = await getCurrentBudgetId();
    _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .doc(budgetId)
        .collection('transactions')
        .snapshots()
        .listen((event) {
      final transactions =
          event.docs.map((e) => Transaction.fromFirestore(e)).toList();
      _transactionsStreamController.add(transactions);
    });
  }

  @override
  Stream<List<Transaction>> get transactions =>
      _transactionsStreamController.asBroadcastStream();

  @override
  Stream<List<Transfer>> getTransfers() =>
      _transfersStreamController.asBroadcastStream();

  @override
  Future<void> createTransaction(Transaction transaction) async {
    final userId = await getUserId();
    final budgetId = await getCurrentBudgetId();
    final ref = await _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .doc(budgetId)
        .collection('transactions');
    ref.add(transaction.toFirestore());
  }

  @override
  Future<void> createTransfer(Transfer transfer) async {
    final url = isTestMode
        ? Uri.http(baseURL, '/api/transfers')
        : Uri.https(baseURL, '/api/transfers');
    final transferResponse = await http.post(url,
        headers: await getHeaders(), body: json.encode(transfer.toJson()));
    final newTransfer = Transfer.fromJson(jsonDecode(transferResponse.body));
    final transfers = [..._transfersStreamController.value];
    transfers.add(newTransfer);
    _transfersStreamController.add(transfers);
  }

  @override
  Future<void> editTransfer(Transfer transfer) async {
    final url = isTestMode
        ? Uri.http(baseURL, '/api/transfers')
        : Uri.https(baseURL, '/api/transfers');
    final transferResponse = await http.put(url,
        headers: await getHeaders(), body: json.encode(transfer.toJson()));
    final editedTransfer = Transfer.fromJson(jsonDecode(transferResponse.body));
    final transfers = [..._transfersStreamController.value];
    final trIndex = transfers.indexWhere((t) => t.id == editedTransfer.id);
    if (trIndex == -1) {
      //throw TodoNotFoundException();
    } else {
      transfers.removeAt(trIndex);
      transfers.insert(trIndex, editedTransfer);
      _transfersStreamController.add(transfers);
    }
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
