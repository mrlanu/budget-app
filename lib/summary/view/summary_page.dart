import 'dart:convert';

import 'package:budget_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../constants/api.dart';

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

class SummaryViewMobile extends StatefulWidget {
  const SummaryViewMobile({super.key});

  @override
  State<SummaryViewMobile> createState() => _SummaryViewMobileState();
}

class _SummaryViewMobileState extends State<SummaryViewMobile> {
  late List<double> _data;

  @override
  void initState() {
    super.initState();
    _data = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    _fetchData();
  }

  Future<void> _fetchData() async {
    final url = isTestMode
        ? Uri.http(baseURL, '/api/summary', {'budgetId': await getBudgetId()})
        : Uri.https(baseURL, '/api/summary', {'budgetId': await getBudgetId()});

    final response = await http.get(url, headers: await getHeaders());
    final result =
        (json.decode(response.body) as List).map((e) => e as double).toList();
    setState(() {
      _data = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: Text('Summary')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SummaryTile(
                title: 'Year: ${DateFormat('yyyy').format(DateTime.now())}',
                income: _data[0],
                expenses: _data[1]),
            SummaryTile(
                title:
                    'Month: ${DateFormat('MMM yyyy').format(DateTime.now())}',
                income: _data[2],
                expenses: _data[3]),
            SummaryTile(
                title:
                    'Week: ${DateFormat('MMM dd').format(DateTime.now().subtract(Duration(days: DateTime.now().day)))} - ${DateFormat('MMM dd').format(DateTime.now().add(Duration(days: 6 - DateTime.now().day)))}',
                income: _data[4],
                expenses: _data[5]),
            SummaryTile(
                title:
                    'Day: ${DateFormat('MMM dd, yyyy').format(DateTime.now())}',
                income: _data[6],
                expenses: _data[7]),
          ],
        ),
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
                          style:
                              textStyle!.copyWith(color: BudgetColors.teal900)),
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
                                  ? theme.error
                                  : BudgetColors.teal900)),
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
