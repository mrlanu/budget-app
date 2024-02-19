import 'dart:async';
import 'dart:convert';

import 'package:budget_app/budgets/budgets.dart';
import 'package:budget_app/shared/models/transaction_interface.dart';
import 'package:budget_app/transfer/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../../constants/api.dart';
import '../transaction.dart';

class TransactionFailure implements Exception {
  final String message;

  const TransactionFailure([
    this.message = 'An unknown exception occurred.',
  ]);
}

abstract class TransactionsRepository {
  Stream<List<ITransaction>> get transactions;

  void fetchTransactions(DateTime dateTime);
  Future<void> createTransaction(Transaction transaction);
  Future<void> updateTransaction(Transaction transaction);

  Future<void> createTransfer(Transfer transfer);
  Future<void> updateTransfer(Transfer transfer);

  Future<Transaction> deleteTransactionOrTransfer(
      {required TransactionTile transaction, required Budget budget});
}

class TransactionsRepositoryImpl extends TransactionsRepository {
  final _transactionsStreamController =
      BehaviorSubject<List<ITransaction>>.seeded(const []);

  @override
  Stream<List<ITransaction>> get transactions =>
      _transactionsStreamController.asBroadcastStream();

  @override
  void fetchTransactions(DateTime dateTime) async {
    final transactions = await _fetchTransactions(dateTime: dateTime);
    final transfers = await _fetchTransfers(dateTime: dateTime);

    _transactionsStreamController.add([...transactions, ...transfers]);
  }

  @override
  Future<void> createTransaction(Transaction transaction) async {
    final url = isTestMode
        ? Uri.http(baseURL, '/api/transactions')
        : Uri.https(baseURL, '/api/transactions');
    final transactionResponse = await http.post(url,
        headers: await getHeaders(), body: json.encode(transaction.toJson()));
    if (transactionResponse.statusCode != 200) {
      throw TransactionFailure(jsonDecode(transactionResponse.body)['message']);
    }
    final newTransaction =
        Transaction.fromJson(jsonDecode(transactionResponse.body));
    final transactions = [..._transactionsStreamController.value];
    transactions.add(newTransaction);
    _transactionsStreamController.add(transactions);
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    final url = isTestMode
        ? Uri.http(baseURL, '/api/transactions')
        : Uri.https(baseURL, '/api/transactions');
    final transactionResponse = await http.put(url,
        headers: await getHeaders(), body: json.encode(transaction.toJson()));
    if (transactionResponse.statusCode != 200) {
      throw TransactionFailure(jsonDecode(transactionResponse.body)['message']);
    }
    final updatedTransaction =
        Transaction.fromJson(jsonDecode(transactionResponse.body));
    final transactions = [..._transactionsStreamController.value];
    final trIndex = transactions.indexWhere((t) => t.getId == transaction.id);
    transactions.removeAt(trIndex);
    transactions.insert(trIndex, transaction);
    _transactionsStreamController.add(transactions);
  }

  @override
  Future<void> createTransfer(Transfer transfer) async {
    final url = isTestMode
        ? Uri.http(baseURL, '/api/transfers')
        : Uri.https(baseURL, '/api/transfers');
    final transferResponse = await http.post(url,
        headers: await getHeaders(), body: json.encode(transfer.toJson()));
    if (transferResponse.statusCode != 200) {
      throw TransactionFailure(jsonDecode(transferResponse.body)['message']);
    }
    final newTransfer =
    Transfer.fromJson(jsonDecode(transferResponse.body));
    final transactions = [..._transactionsStreamController.value];
    transactions.add(newTransfer);
    _transactionsStreamController.add(transactions);
  }

  @override
  Future<void> updateTransfer(Transfer transfer) async {
    final url = isTestMode
        ? Uri.http(baseURL, '/api/transfers')
        : Uri.https(baseURL, '/api/transfers');
    final transferResponse = await http.put(url,
        headers: await getHeaders(), body: json.encode(transfer.toJson()));
    if (transferResponse.statusCode != 200) {
      throw TransactionFailure(jsonDecode(transferResponse.body)['message']);
    }
    final updatedTransfer =
    Transfer.fromJson(jsonDecode(transferResponse.body));
    final transactions = [..._transactionsStreamController.value];
    final trIndex = transactions.indexWhere((t) => t.getId == transfer.id);
    transactions.removeAt(trIndex);
    transactions.insert(trIndex, transfer);
    _transactionsStreamController.add(transactions);
  }

  @override
  Future<Transaction> deleteTransactionOrTransfer(
      {required TransactionTile transaction, required Budget budget}) async {
    return Transaction();
  }

  Future<List<Transaction>> _fetchTransactions({
    required DateTime dateTime,
  }) async {
    final url = isTestMode
        ? Uri.http(baseURL, '/api/transactions', {
      'budgetId': await getCurrentBudgetId(),
      'date': dateTime.toString()
    })
        : Uri.https(baseURL, '/api/transactions', {
      'budgetId': await getCurrentBudgetId(),
      'date': dateTime.toString()
    });

    final response = await http.get(url, headers: await getHeaders());
    final result = List<Map<String, dynamic>>.from(
      json.decode(response.body) as List,
    ).map((jsonMap) => Transaction.fromJson(jsonMap)).toList();
    return result;
  }

  Future<List<Transfer>> _fetchTransfers({
    required DateTime dateTime,
  }) async {
    final url = isTestMode
        ? Uri.http(baseURL, '/api/transfers', {
      'budgetId': await getCurrentBudgetId(),
      'date': dateTime.toString()
    })
        : Uri.https(baseURL, '/api/transfers', {
      'budgetId': await getCurrentBudgetId(),
      'date': dateTime.toString()
    });

    final response = await http.get(url, headers: await getHeaders());
    final result = List<Map<String, dynamic>>.from(
      json.decode(response.body) as List,
    ).map((jsonMap) => Transfer.fromJson(jsonMap)).toList();
    return result;
  }
}
