import 'package:qruto_budget/charts/models/year_month_sum.dart';
import 'package:drift/drift.dart';

import '../../database/database.dart';
import '../../transaction/models/transaction_type.dart';

abstract class ChartRepository {
  Future<List<YearMonthSum>> fetchTrendChartData();

  Future<List<YearMonthSum>> fetchCategoryChartData(int categoryId);

  Future<List<YearMonthSum>> fetchSubcategoryChartData(int id);
}

class ChartRepositoryDrift extends ChartRepository {
  ChartRepositoryDrift({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  @override
  Future<List<YearMonthSum>> fetchTrendChartData() async {
    return _getSumsOfIncomesExpensesForYearByMonth();
  }

  Future<List<YearMonthSum>> _getSumsOfIncomesExpensesForYearByMonth() async {
    final now = DateTime.now();
    // Start: One year ago at 00:00:00
    final dateStart = DateTime(now.year - 1, now.month, 1, 0, 0, 0);
    // End: Today at 23:59:59
    final dateEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

    // Fetch transactions for the past year
    final transactions = await (_database.select(_database.transactions)
          ..where((t) => t.date.isBetweenValues(dateStart, dateEnd)))
        .get();

    // Group transactions by type and month
    final Map<TransactionType, Map<DateTime, double>> groupedTransactions = {};
    for (final transaction in transactions) {
      final type = transaction.type;
      final month = DateTime(transaction.date.year, transaction.date.month, 1);
      final amount = transaction.amount;

      groupedTransactions.putIfAbsent(type, () => {});
      groupedTransactions[type]![month] =
          (groupedTransactions[type]![month] ?? 0.0) + amount;
    }

    // Generate the result for each month in the past year
    final result = <YearMonthSum>[];
    for (int i = 0; i <= 12; i++) {
      final month = DateTime(dateStart.year, dateStart.month + i, 1);
      final expenseSum =
          groupedTransactions[TransactionType.EXPENSE]?[month] ?? 0.0;
      final incomeSum =
          groupedTransactions[TransactionType.INCOME]?[month] ?? 0.0;

      result.add(YearMonthSum(
        date: month,
        expenseSum: expenseSum,
        incomeSum: incomeSum,
      ));
    }

    return result;
  }

  @override
  Future<List<YearMonthSum>> fetchCategoryChartData(int categoryId) =>
      _getSumsByCategoryAndMonth(true, categoryId);

  @override
  Future<List<YearMonthSum>> fetchSubcategoryChartData(int subcategoryId) =>
      _getSumsByCategoryAndMonth(false, subcategoryId);

  Future<List<YearMonthSum>> _getSumsByCategoryAndMonth(
      bool isCategory, int categoryId) async {
    final now = DateTime.now();
    // Start: One year ago at 00:00:00
    final dateStart = DateTime(now.year - 1, now.month, 1, 0, 0, 0);
    // End: Today at 23:59:59
    final dateEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

    // Fetch transactions for the past year
    final transactions = isCategory
        ? await (_database.select(_database.transactions)
              ..where((t) =>
                  t.categoryId.equals(categoryId) &
                  t.date.isBetweenValues(dateStart, dateEnd)))
            .get()
        : await (_database.select(_database.transactions)
              ..where((t) =>
                  t.subcategoryId.equals(categoryId) &
                  t.date.isBetweenValues(dateStart, dateEnd)))
            .get();

    // Group transactions by month and sum their amounts
    final Map<DateTime, double> monthlySums = {};
    for (final transaction in transactions) {
      final month = DateTime(transaction.date.year, transaction.date.month, 1);
      monthlySums[month] = (monthlySums[month] ?? 0.0) + transaction.amount;
    }

    // Generate the result for each month in the past year
    final result = <YearMonthSum>[];
    for (int i = 0; i <= 12; i++) {
      final month = DateTime(dateStart.year, dateStart.month + i, 1);
      final expenseSum = monthlySums[month] ?? 0.0;

      result.add(YearMonthSum(
        date: month,
        expenseSum: expenseSum,
        incomeSum: 0.0,
      ));
    }

    return result;
  }
}
