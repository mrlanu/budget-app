import 'package:qruto_budget/charts/models/net_worth_month_point.dart';
import 'package:qruto_budget/charts/models/year_month_sum.dart';
import 'package:drift/drift.dart';

import '../../database/database.dart';
import '../../transaction/models/transaction_type.dart';

enum NetWorthAggregation { monthly, yearly }

abstract class ChartRepository {
  Future<List<YearMonthSum>> fetchTrendChartData();

  Future<List<YearMonthSum>> fetchCategoryChartData(int categoryId);

  Future<List<YearMonthSum>> fetchSubcategoryChartData(int id);

  /// Opening net worth on the first day of each month for the last 12 months (Option A replay).
  ///
  /// When [includeHiddenAccounts] is false, only accounts included in totals (`include_in_total`) count.
  /// When true, every account is summed (those excluded from totals are usually treated as “hidden”).
  Future<List<NetWorthMonthPoint>> fetchNetWorthOpeningBalances({
    bool includeHiddenAccounts = false,
    NetWorthAggregation aggregation = NetWorthAggregation.monthly,
  });
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

  /// First instant of calendar month containing [ref].
  DateTime _monthStart(DateTime ref) =>
      DateTime(ref.year, ref.month, 1, 0, 0, 0);

  /// Add whole calendar months (negative allowed).
  DateTime _addMonths(DateTime start, int deltaMonths) {
    final totalMonths = start.year * 12 + start.month - 1 + deltaMonths;
    final y = totalMonths ~/ 12;
    final m = totalMonths % 12 + 1;
    return DateTime(y, m, 1, start.hour, start.minute, start.second);
  }

  @override
  Future<List<NetWorthMonthPoint>> fetchNetWorthOpeningBalances({
    bool includeHiddenAccounts = false,
    NetWorthAggregation aggregation = NetWorthAggregation.monthly,
  }) async {
    final accounts = await _database.select(_database.accounts).get();
    final balances = <int, double>{
      for (final a in accounts) a.id: a.balance,
    };

    final txs = await (_database.select(_database.transactions)
          ..orderBy([
            (t) => OrderingTerm.desc(t.date),
            (t) => OrderingTerm.desc(t.id),
          ]))
        .get();

    final now = DateTime.now();
    final cutoffs = aggregation == NetWorthAggregation.monthly
        ? _monthlyCutoffs(now)
        : _yearlyCutoffs(now);

    final includedIds = includeHiddenAccounts
        ? accounts.map((a) => a.id).toSet()
        : accounts.where((a) => a.includeInTotal).map((a) => a.id).toSet();

    double netWorthTotal() =>
        includedIds.fold<double>(0, (sum, id) => sum + (balances[id] ?? 0));

    // Reverse replay: current balances -> opening balances at month cutoffs.
    void rollback(Transaction tx) {
      switch (tx.type) {
        case TransactionType.EXPENSE:
          final id = tx.fromAccountId;
          balances[id] = (balances[id] ?? 0) + tx.amount;
          break;
        case TransactionType.INCOME:
          final id = tx.fromAccountId;
          balances[id] = (balances[id] ?? 0) - tx.amount;
          break;
        case TransactionType.TRANSFER:
          final from = tx.fromAccountId;
          balances[from] = (balances[from] ?? 0) + tx.amount;
          final to = tx.toAccountId;
          if (to != null) {
            balances[to] = (balances[to] ?? 0) - tx.amount;
          }
          break;
        case TransactionType.ACCOUNT:
          break;
      }
    }

    final resultDesc = <NetWorthMonthPoint>[];
    var txIdx = 0;

    for (final cutoff in cutoffs.reversed) {
      while (txIdx < txs.length && !txs[txIdx].date.isBefore(cutoff)) {
        rollback(txs[txIdx]);
        txIdx++;
      }
      resultDesc.add(NetWorthMonthPoint(
        monthStart: cutoff,
        totalBalance: netWorthTotal(),
      ));
    }

    return resultDesc.reversed.toList();
  }

  List<DateTime> _monthlyCutoffs(DateTime now) {
    final currentStart = _monthStart(now);
    final firstCutoff = _addMonths(currentStart, -11);
    return List<DateTime>.generate(
      12,
      (i) => _addMonths(firstCutoff, i),
    );
  }

  List<DateTime> _yearlyCutoffs(DateTime now) {
    final currentYearStart = DateTime(now.year, 1, 1, 0, 0, 0);
    return List<DateTime>.generate(
      12,
      (i) => DateTime(currentYearStart.year - 11 + i, 1, 1, 0, 0, 0),
    );
  }
}
