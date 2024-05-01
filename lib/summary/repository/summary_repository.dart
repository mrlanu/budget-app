import 'package:collection/collection.dart';
import 'package:isar/isar.dart';

import '../../transaction/models/transaction.dart';
import '../../transaction/models/transaction_type.dart';

class SummaryRepository {
  SummaryRepository({required this.isar});

  final Isar isar;

  Future<List<Transaction>> findAllByBudgetIdAndDateBetween(
      DateTime start, DateTime end) async {
    return isar.transactions.filter().dateBetween(start, end).findAll();
  }

  Future<List<double>> getSummary() async {
    var now = DateTime.now().toLocal();
    var transactionsForYear = await findAllByBudgetIdAndDateBetween(
        DateTime(now.year, 1, 1), DateTime(now.year, 12, 31));

    final result = <double>[];
    _groupTransaction(transactionsForYear).forEach((key, value) {
      final double sum = value.fold<double>(
          0.0, (previousValue, element) => previousValue + element.amount);
      result.add(sum);
    });

    final transactionsForMonth = transactionsForYear
        .where((transaction) => transaction.date.month == now.month).toList();

    _groupTransaction(transactionsForMonth).forEach((key, value) {
      final double sum = value.fold<double>(
          0.0, (previousValue, element) => previousValue + element.amount);
      result.add(sum);
    });

    final transactionsForWeek = transactionsForYear.where((transaction) =>
    transaction.date
        .isAfter(now.subtract(Duration(days: now.weekday))) &&
        transaction.date.isBefore(now.add(Duration(days: 7 - now.weekday)))).toList();

    _groupTransaction(transactionsForWeek).forEach((key, value) {
      final double sum = value.fold<double>(
          0.0, (previousValue, element) => previousValue + element.amount);
      result.add(sum);
    });

    final transactionsForToday = transactionsForYear.where((transaction) =>
    transaction.date.year == now.year &&
        transaction.date.month == now.month &&
        transaction.date.day == now.day).toList();

    _groupTransaction(transactionsForToday).forEach((key, value) {
      final double sum = value.fold<double>(
          0.0, (previousValue, element) => previousValue + element.amount);
      result.add(sum);
    });

    return result;
  }

  Map<TransactionType, List<Transaction>> _groupTransaction(
          List<Transaction> transactions) =>
      groupBy(transactions, (Transaction tr) => tr.type);
}
