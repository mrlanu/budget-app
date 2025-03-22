import 'package:qruto_budget/database/database.dart';
import 'package:drift/drift.dart' as db;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../transaction/models/transaction_type.dart';
import '../../utils/theme/budget_theme.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key, required AppDatabase database})
      : _database = database;

  final AppDatabase _database;

  Future<List<double>> _calculateSummary() async {
    final today = DateTime.now().toLocal();
    final firstDayOfYear = DateTime(today.year, 1, 1);
    final lastDayOfYear = DateTime(today.year, 12, 31, 23, 59, 59);

    // Fetch transactions for the year
    final transactionsForYear = await (_database
            .select(_database.transactions)
          ..where((t) => t.date.isBetweenValues(firstDayOfYear, lastDayOfYear)))
        .get();

    // Helper function to group transactions by type and sum amounts
    Map<TransactionType, double> _groupAndSum(List<Transaction> transactions) {
      final result = <TransactionType, double>{};
      for (final transaction in transactions) {
        final type = transaction.type;
        final amount = transaction.amount;
        result[type] = (result[type] ?? 0.0) + amount;
      }
      return result;
    }

    // Group and sum transactions for the year
    final dataForYear = _groupAndSum(transactionsForYear);

    // Filter transactions for the current month
    final transactionsForMonth =
        transactionsForYear.where((t) => t.date.month == today.month).toList();
    final dataForMonth = _groupAndSum(transactionsForMonth);

    // Filter transactions for the current week
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    final transactionsForWeek = transactionsForYear
        .where((t) => t.date.isAfter(startOfWeek) && t.date.isBefore(endOfWeek))
        .toList();
    final dataForWeek = _groupAndSum(transactionsForWeek);

    // Filter transactions for today
    final transactionsForToday = transactionsForYear
        .where((t) =>
            t.date.year == today.year &&
            t.date.month == today.month &&
            t.date.day == today.day)
        .toList();
    final dataForToday = _groupAndSum(transactionsForToday);

    return [
        dataForYear[TransactionType.INCOME] ?? 0.0,
        dataForYear[TransactionType.EXPENSE] ?? 0.0,
        dataForMonth[TransactionType.INCOME] ?? 0.0,
        dataForMonth[TransactionType.EXPENSE] ?? 0.0,
        dataForWeek[TransactionType.INCOME] ?? 0.0,
        dataForWeek[TransactionType.EXPENSE] ?? 0.0,
        dataForToday[TransactionType.INCOME] ?? 0.0,
        dataForToday[TransactionType.EXPENSE] ?? 0.0,
      ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: Text('Summary', style: TextStyle(fontSize: 30.sp))),
      body: FutureBuilder(
          future: _calculateSummary(),
          builder: (context, snapshot) {
            if (snapshot.hasData){
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SummaryTile(
                        title: 'Year: ${DateFormat('yyyy').format(DateTime.now())}',
                        income: snapshot.data![0],
                        expenses: snapshot.data![1]),
                    SummaryTile(
                        title:
                        'Month: ${DateFormat('MMM yyyy').format(DateTime.now())}',
                        income: snapshot.data![2],
                        expenses: snapshot.data![3]),
                    SummaryTile(
                        title:
                        'Week: ${DateFormat('MMM dd').format(DateTime.now().subtract(Duration(days: DateTime.now().day)))} - ${DateFormat('MMM dd').format(DateTime.now().add(Duration(days: 6 - DateTime.now().day)))}',
                        income: snapshot.data![4],
                        expenses: snapshot.data![5]),
                    SummaryTile(
                        title:
                        'Day: ${DateFormat('MMM dd, yyyy').format(DateTime.now())}',
                        income: snapshot.data![6],
                        expenses: snapshot.data![7]),
                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator(),);
            }
          },
        ),
      ),
    );
  }
}

class SummaryTile extends StatelessWidget {
  final String title;
  final double income;
  final double expenses;

  const SummaryTile(
      {super.key,
      required this.title,
      required this.income,
      required this.expenses});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w500);
    final theme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text(
            '$title',
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600),
          ),
          Card(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('Income', style: textStyle),
                      Expanded(child: Container()),
                      Text('\$ ${income.toStringAsFixed(2)}',
                          style: textStyle!.copyWith(
                              color: BudgetTheme.isDarkMode(context)
                                  ? BudgetColors.lightContainer
                                  : BudgetColors.primary)),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text('Expenses', style: textStyle),
                      Expanded(child: Container()),
                      Text('\$ ${expenses.toStringAsFixed(2)}',
                          style: textStyle.copyWith(color: theme.error)),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text('Balance', style: textStyle),
                      Expanded(child: Container()),
                      Text('\$ ${(income - expenses).toStringAsFixed(2)}',
                          style: textStyle.copyWith(
                              color: (income - expenses) < 0
                                  ? BudgetColors.error
                                  : BudgetTheme.isDarkMode(context)
                                      ? BudgetColors.lightContainer
                                      : BudgetColors.primary)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
