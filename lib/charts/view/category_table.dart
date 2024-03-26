import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/colors.dart';
import '../../utils/theme/budget_theme.dart';
import '../cubit/chart_cubit.dart';

class CategoryTable extends StatelessWidget {
  const CategoryTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartCubit, ChartState>(
      builder: (context, state) {
        final sumExp = state.data.fold(0.0,
            (previousValue, element) => previousValue + element.expenseSum);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: Column(
            children: [
              Table(
                border: TableBorder.all(
                    color: BudgetTheme.isDarkMode(context)
                        ? BudgetColors.darkerGrey
                        : Colors.grey),
                columnWidths: const <int, TableColumnWidth>{
                  0: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                      decoration: BoxDecoration(
                          color: BudgetTheme.isDarkMode(context)
                              ? BudgetColors.darkerGrey
                              : Colors.white60),
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: Text(
                                style: Theme.of(context).textTheme.titleLarge,
                                'Date')),
                        Align(
                            alignment: Alignment.center,
                            child: Text(
                                style: Theme.of(context).textTheme.titleLarge,
                                'Spent')),
                      ]),
                  TableRow(
                      decoration: BoxDecoration(color: Colors.white54),
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
                                  '\$ ${sumExp.toStringAsFixed(2)}')),
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
                      2: FlexColumnWidth(),
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
                                              '\$ ${e.expenseSum.toStringAsFixed(2)}'),
                                        ))),
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
