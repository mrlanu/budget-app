import 'dart:core';

import 'package:budget_app/summary/repository/summary_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../utils/theme/budget_theme.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => SummaryPage());
  }

  @override
  Widget build(BuildContext context) {
    return SummaryViewMobile();
  }
}

class SummaryViewMobile extends StatelessWidget {
  const SummaryViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: Text('Summary')),
      body: FutureBuilder(
        future: context.read<SummaryRepository>().getSummary(),
        builder: (BuildContext context, AsyncSnapshot<List<double>> snapshot) {
          return snapshot.hasData
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      SummaryTile(
                          title:
                              'Year: ${DateFormat('yyyy').format(DateTime.now())}',
                          income: snapshot.data![1],
                          expenses: snapshot.data![0]),
                      SummaryTile(
                          title:
                              'Month: ${DateFormat('MMM yyyy').format(DateTime.now())}',
                          income: snapshot.data![3],
                          expenses: snapshot.data![2]),
                      SummaryTile(
                          title:
                              'Week: ${DateFormat('MMM dd').format(DateTime.now().subtract(Duration(days: DateTime.now().day)))} - ${DateFormat('MMM dd').format(DateTime.now().add(Duration(days: 6 - DateTime.now().day)))}',
                          income: snapshot.data![5],
                          expenses: snapshot.data![4]),
                      SummaryTile(
                          title:
                              'Day: ${DateFormat('MMM dd, yyyy').format(DateTime.now())}',
                          income: snapshot.data![7],
                          expenses: snapshot.data![6]),
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    ));
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
    final textStyle = Theme.of(context).textTheme.titleLarge;
    final theme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text(
            '$title',
            style: textStyle,
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
