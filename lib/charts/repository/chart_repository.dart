import 'package:budget_app/categories/models/category.dart';
import 'package:budget_app/charts/models/year_month_sum.dart';
import 'package:budget_app/transaction/models/models.dart';
import 'package:collection/collection.dart';
import 'package:isar/isar.dart';

abstract class ChartRepository {
  Future<List<YearMonthSum>> fetchTrendChartData();

  Future<List<YearMonthSum>> fetchCategoryChartData(int categoryId);
}

class ChartRepositoryImpl extends ChartRepository {
  ChartRepositoryImpl({required Isar isar}) : _isar = isar;

  final Isar _isar;

  @override
  Future<List<YearMonthSum>> fetchTrendChartData() async {
    final result = <YearMonthSum>[];
    final datesRange = _getDatesRange();
    var transactionsForYear =
        await _findAllTransactionsByDateBetween(datesRange.start, datesRange.end);
    final groupedTrs =
        groupBy(transactionsForYear, (Transaction tr) => tr.date.month);
    for (var i = 0; i <= 11; i++) {
      final month = datesRange.start.copyWith(month: datesRange.start.month + i);
      final trs = groupedTrs[month.month] ?? [];
      final double sumExpenses = trs
          .where((t) => t.type == TransactionType.EXPENSE)
          .fold<double>(
              0.0, (previousValue, element) => previousValue + element.amount);
      final double sumIncomes = trs
          .where((t) => t.type == TransactionType.INCOME)
          .fold<double>(
              0.0, (previousValue, element) => previousValue + element.amount);
      result.add(YearMonthSum(
          date: '${month.year}-${month.month}',
          expenseSum: sumExpenses,
          incomeSum: sumIncomes));
    }

    return result;
  }

  Future<List<Transaction>> _findAllTransactionsByDateBetween(
      DateTime start, DateTime end) async {
    return _isar.transactions.filter().dateBetween(start, end).findAll();
  }

  @override
  Future<List<YearMonthSum>> fetchCategoryChartData(int categoryId) async {
    final result = <YearMonthSum>[];
    final datesRange = _getDatesRange();
    final categoryTrs = await _isar.transactions
        .filter()
        .dateBetween(datesRange.start, datesRange.end)
        .category((c) => c.idEqualTo(categoryId))
        .findAll();
    final groupedTrs = groupBy(categoryTrs, (Transaction tr) => tr.date.month);
    for (var i = 0; i <= 11; i++) {
      final month = datesRange.start.copyWith(month: datesRange.start.month + i);
      final trs = groupedTrs[month.month] ?? [];
      final double sumExpenses = trs
          .fold<double>(
          0.0, (previousValue, element) => previousValue + element.amount);
      result.add(YearMonthSum(
          date: '${month.year}-${month.month}',
          expenseSum: sumExpenses,
          incomeSum: 0.0));
    }
    return result;
  }

  DateRange _getDatesRange(){
  var now = DateTime.now().toLocal();
  final start = DateTime(now.year - 1, now.month + 1, now.day);
  final end = DateTime(now.year, now.month, now.day + 1);
  return (start: start, end: end);
  }
}

typedef DateRange = ({DateTime start, DateTime end});
