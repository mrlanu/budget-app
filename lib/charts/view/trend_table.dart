import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/theme/budget_theme.dart';
import '../cubit/chart_cubit.dart';

class TrendTable extends StatelessWidget {
  const TrendTable({super.key});

  @override
  Widget build(BuildContext context) {
    final isThemeDark = BudgetTheme.isDarkMode(context);
    return BlocBuilder<ChartCubit, ChartState>(
      builder: (context, state) {
        final sumInc = state.data.fold(
            0.0, (previousValue, element) => previousValue + element.incomeSum);
        final sumExp = state.data.fold(0.0,
            (previousValue, element) => previousValue + element.expenseSum);
        final balanceSum = sumInc - sumExp;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: Column(
            children: [
              Table(
                border: TableBorder.all(color: Colors.grey),
                columnWidths: const <int, TableColumnWidth>{
                  0: FlexColumnWidth(),
                  1: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                  3: FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                            style: Theme.of(context).textTheme.bodySmall,
                            'Date')),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                            style: Theme.of(context).textTheme.bodySmall,
                            'Income')),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                            style: Theme.of(context).textTheme.bodySmall,
                            'Expenses')),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                            style: Theme.of(context).textTheme.bodySmall,
                            'Balance')),
                  ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: balanceSum <= 0
                            ? isThemeDark
                                ? Color.fromRGBO(145, 55, 55, 1.0)
                                : Color.fromRGBO(255, 227, 227, 1.0)
                            : isThemeDark
                                ? Color.fromRGBO(75, 133, 66, 1.0)
                                : Color.fromRGBO(221, 255, 216, 1.0),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      'Total'),
                                  Icon(
                                    Icons.arrow_forward_outlined,
                                    size: 15,
                                  )
                                ],
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  '\$ ${sumInc.toStringAsFixed(2)}')),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  '\$ ${sumExp.toStringAsFixed(2)}')),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  '\$ ${balanceSum.toStringAsFixed(2)}')),
                        ),
                      ]),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Table(
                    border: TableBorder.all(color: Colors.grey),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(),
                      1: FlexColumnWidth(),
                      2: FlexColumnWidth(),
                      3: FlexColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: <TableRow>[
                      ...state.data.reversed
                          .map(
                            (e) => TableRow(
                              children: <Widget>[
                                TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                              '${e.date}'),
                                        ))),
                                TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                              '\$ ${e.incomeSum.toStringAsFixed(2)}'),
                                        ))),
                                TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                              '\$ ${e.expenseSum.toStringAsFixed(2)}'),
                                        ))),
                                TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Container(
                                      color: e.incomeSum - e.expenseSum == 0
                                          ? null
                                          : e.incomeSum - e.expenseSum <= 0
                                              ? isThemeDark
                                                  ? Color.fromRGBO(
                                                      145, 55, 55, 1.0)
                                                  : Color.fromRGBO(
                                                      255, 227, 227, 1.0)
                                              : isThemeDark
                                                  ? Color.fromRGBO(
                                                      75, 133, 66, 1.0)
                                                  : Color.fromRGBO(
                                                      221, 255, 216, 1.0),
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                    fontWeight:
                                                    FontWeight.bold),
                                                '\$ ${(e.incomeSum - e.expenseSum).toStringAsFixed(2)}'),
                                          )),
                                    )),
                              ],
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
