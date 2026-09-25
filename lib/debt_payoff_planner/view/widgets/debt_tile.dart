import 'package:qruto_budget/debt_payoff_planner/cubits/debt_cubit/debts_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../database/database.dart';
import '../../../utils/theme/budget_theme.dart';
import '../../../utils/theme/cubit/theme_cubit.dart';

class DebtTile extends StatelessWidget {
  final Debt debtModel;
  final Payment? lastPayment;
  final Function(Debt) onEdit;
  final Function(Debt) onRecordPayment;
  final Function(Debt) onViewHistory;

  const DebtTile({
    super.key,
    required this.debtModel,
    this.lastPayment,
    required this.onEdit,
    required this.onRecordPayment,
    required this.onViewHistory,
  });

  int get _completedPercent {
    if (debtModel.startBalance <= 0) {
      return debtModel.currentBalance <= 0 ? 100 : 0;
    }
    final ratio = 1 - (debtModel.currentBalance / debtModel.startBalance);
    return (ratio * 100).clamp(0, 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeCubit>().state;
    final lastPaymentText = lastPayment == null
        ? '--'
        : '\$ ${lastPayment!.amount.toStringAsFixed(2)}';

    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 0, left: 15, right: 0, bottom: 0),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10.0),
                bottomRight: Radius.zero,
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.zero,
              ),
              color: themeState.primaryColor[600],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      debtModel.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.white),
                    ),
                    Text(
                      '${debtModel.apr} % APR',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
                OverflowBar(
                  children: [
                    IconButton.outlined(
                      color: Colors.white,
                      tooltip: 'Record payment',
                      onPressed: debtModel.currentBalance > 0
                          ? () => onRecordPayment(debtModel)
                          : null,
                      icon: const Icon(Icons.payments_outlined),
                    ),
                    IconButton.outlined(
                      color: Colors.white,
                      tooltip: 'Edit',
                      onPressed: () => onEdit(debtModel),
                      icon: const Icon(Icons.edit_note),
                    ),
                    IconButton.outlined(
                      color: Colors.white,
                      tooltip: 'Delete',
                      onPressed: () {
                        context.read<DebtsCubit>().deleteDebt(debtModel.id);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: BudgetTheme.isDarkMode(context)
                  ? themeState.primaryColor[400]
                  : themeState.primaryColor[100],
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('MM-dd-yyyy')
                            .format(debtModel.nextPaymentDue),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'PAYMENT DUE',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Expanded(child: SizedBox()),
                      Text(lastPaymentText),
                      Text(
                        'LAST PAYMENT',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$ ${debtModel.minimumPayment}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'MIN PAYMENT',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Expanded(child: SizedBox()),
                      Text(
                        '\$ ${debtModel.currentBalance.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'CURRENT BALANCE',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => onViewHistory(debtModel),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.zero,
                  bottomRight: Radius.circular(10.0),
                  topLeft: Radius.zero,
                  bottomLeft: Radius.circular(10.0),
                ),
                color: themeState.primaryColor[600],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Completed: ',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white),
                  ),
                  Text(
                    '$_completedPercent %',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
