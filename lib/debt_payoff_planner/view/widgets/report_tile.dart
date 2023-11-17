import 'package:budget_app/debt_payoff_planner/models/debt_report_item.dart';
import 'package:budget_app/debt_payoff_planner/models/debt_strategy_report.dart';
import 'package:budget_app/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class ReportTile extends StatelessWidget {
  final DebtStrategyReport report;

  const ReportTile({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 15),
      child: Column(
        children: [
          Container(
              alignment: Alignment.center,
              height: 35,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.zero,
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.zero),
                  color: BudgetTheme.isDarkMode(context)
                      ? BudgetColors.primary600
                      : BudgetColors.lightContainer),
              child: Text('DURATION ${report.duration} MONTHS',
                  style: Theme.of(context).textTheme.titleSmall)),
          Container(
            height: report.extraPayments.length * 45,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (DebtReportItem item in report.extraPayments)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${item.name}',
                          style: item.paid
                              ? textTheme.titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold)
                              : textTheme.titleMedium!),
                      item.paid
                          ? Text('LAST PAYMENT',
                              style: textTheme.titleSmall!
                                  .copyWith(fontWeight: FontWeight.bold))
                          : Container(),
                      Text('\$ ${item.amount.toStringAsFixed(2)}',
                          style: item.paid
                              ? textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold)
                              : textTheme.titleMedium!),
                    ],
                  ),
              ],
            ),
          ),
          report.minPayments.length > 0
              ? Container(
                  height: report.minPayments.length * 60,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.zero,
                        bottomRight: Radius.circular(10.0),
                        topLeft: Radius.zero,
                        bottomLeft: Radius.circular(10.0)),
                    color: Color.fromRGBO(231, 231, 231, 1.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('AND MIN PAYMENT FOR:',
                          style: Theme.of(context).textTheme.bodySmall),
                      for (DebtReportItem item in report.minPayments)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${item.name}', style: textTheme.titleMedium),
                            Text('\$ ${item.amount.toStringAsFixed(2)}',
                                style: textTheme.titleMedium),
                          ],
                        ),
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
