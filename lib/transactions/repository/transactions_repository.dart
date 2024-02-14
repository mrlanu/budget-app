import 'dart:async';
import 'dart:convert';

import 'package:budget_app/budgets/budgets.dart';
import 'package:budget_app/shared/models/transaction_interface.dart';
import 'package:budget_app/transactions/models/transaction.dart';
import 'package:budget_app/transactions/models/transaction_tile.dart';
import 'package:budget_app/transfer/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../../constants/api.dart';

abstract class TransactionsRepository {
  void initTransactions(DateTime dateTime);

  Stream<List<ITransaction>> get transactions;

  Future<void> fetchTransactions({
    required DateTime dateTime,
  });

  Future<List<Transfer>> fetchTransfers({
    required DateTime dateTime,
  });

  Future<void> createTransaction(Transaction transaction);

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

  @override
  Stream<List<ITransaction>> get transactions =>
      _transactionsStreamController.asBroadcastStream();

  void initTransactions(DateTime dateTime) async {
    final transactions = await fetchTransactions(dateTime: dateTime);
    final transfers = await fetchTransfers(dateTime: dateTime);

      _transactionsStreamController.add([...transactions, ...transfers]);
  }

  @override
  Future<List<Transaction>> fetchTransactions({
    required DateTime dateTime,
  }) async {
    final url = isTestMode
        ? Uri.http(baseURL, '/api/transactions',
        {'budgetId': await getCurrentBudgetId(), 'date': dateTime.toString()})
        : Uri.https(baseURL, '/api/transactions',
        {'budgetId': await getCurrentBudgetId(), 'date': dateTime.toString()});

    final response = await http.get(url, headers: await getHeaders());
    final result = List<Map<String, dynamic>>.from(
      json.decode(response.body) as List,
    ).map((jsonMap) => Transaction.fromJson(jsonMap)).toList();
    return result;
  }

  @override
  Future<List<Transfer>> fetchTransfers({
    required DateTime dateTime,
  }) async {
    final url = isTestMode
        ? Uri.http(baseURL, '/api/transfers',
        {'budgetId': await getCurrentBudgetId(), 'date': dateTime.toString()})
        : Uri.https(baseURL, '/api/transfers',
        {'budgetId': await getCurrentBudgetId(), 'date': dateTime.toString()});

    final response = await http.get(url, headers: await getHeaders());
    final result = List<Map<String, dynamic>>.from(
      json.decode(response.body) as List,
    ).map((jsonMap) => Transfer.fromJson(jsonMap)).toList();
    return result;
  }

  @override
  Future<void> createTransaction(Transaction transaction) async {
    final url = isTestMode
        ? Uri.http(baseURL, '/api/transactions')
        : Uri.https(baseURL, '/api/transactions');
    final transactionResponse = await http.post(url,
        headers: await getHeaders(), body: json.encode(transaction.toJson()));
    final newTransaction =
    Transaction.fromJson(jsonDecode(transactionResponse.body));
    final transactions = [..._transactionsStreamController.value];
    final trIndex = transactions.indexWhere((t) => t.getId == newTransaction.id);
    if (trIndex == -1) {
      transactions.add(newTransaction);
      _transactionsStreamController.add(transactions);
    } else {
      transactions.removeAt(trIndex);
      transactions.insert(trIndex, transaction);
      _transactionsStreamController.add(transactions);
    }
  }

  @override
  Future<void> saveTransfer(
      {required Transfer transfer,
      required Budget budget,
      TransactionTile? editedTransaction}) async {

  }

  @override
  Future<Transaction> deleteTransactionOrTransfer(
      {required TransactionTile transaction, required Budget budget}) async {

    return Transaction();
  }
}
