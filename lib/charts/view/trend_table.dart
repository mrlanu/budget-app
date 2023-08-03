import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/chart_cubit.dart';

class TrendTable extends StatelessWidget {
  const TrendTable({super.key});

  @override
  Widget build(BuildContext context) {
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
                            style: TextStyle(fontWeight: FontWeight.bold),
                            'Date')),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                            style: TextStyle(fontWeight: FontWeight.bold),
                            'Income')),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                            style: TextStyle(fontWeight: FontWeight.bold),
                            'Expenses')),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                            style: TextStyle(fontWeight: FontWeight.bold),
                            'Balance')),
                  ]),
                  TableRow(
                      decoration: BoxDecoration(
                        color: balanceSum <= 0
                            ? Color.fromRGBO(255, 227, 227, 1.0)
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
                                              style: TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .fontSize),
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
                                              style: TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .fontSize),
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
                                              style: TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .fontSize),
                                              '\$ ${e.expenseSum.toStringAsFixed(2)}'),
                                        ))),
                                TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Container(
                                      color: e.incomeSum - e.expenseSum <= 0
                                          ? Color.fromRGBO(255, 227, 227, 1.0)
                                          : Color.fromRGBO(221, 255, 216, 1.0),
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .fontSize),
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
