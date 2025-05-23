import 'package:qruto_budget/debt_payoff_planner/cubits/debt_cubit/debts_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../database/database.dart';
import '../../../utils/theme/budget_theme.dart';
import '../../../utils/theme/cubit/theme_cubit.dart';

class DebtTile extends StatelessWidget {
  final Debt debtModel;
  final Function onEdit;

  const DebtTile({super.key, required this.debtModel, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeCubit>().state;
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.only(top: 0, left: 15, right: 0, bottom: 0),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.zero,
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.zero),
                color: themeState.primaryColor[600]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(debtModel.name,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
                      Text(
                        '${debtModel.apr} % APR',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  ButtonBar(
                    children: [
                      IconButton.outlined(
                        color: Colors.white,
                          onPressed: () => onEdit(debtModel),
                          icon: const Icon(Icons.edit_note)),
                      IconButton.outlined(
                          color: Colors.white,
                          onPressed: () {
                            context.read<DebtsCubit>().deleteDebt(debtModel.id!);
                            //context.read<StrategyCubit>().fetchStrategy();
                          },
                          icon: const Icon(Icons.delete)),
                    ],
                  )
                ],
              )),
          Expanded(
            child: Container(
              color: BudgetTheme.isDarkMode(context)
                  ? themeState.primaryColor[400]
                  : themeState.primaryColor[100],
              padding: EdgeInsets.all(15),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${DateFormat('MM-dd-yyyy').format(debtModel.nextPaymentDue)}',
                            style: Theme.of(context).textTheme.titleMedium),
                        Text('PAYMENT DUE',
                            style: Theme.of(context).textTheme.bodySmall),
                        Expanded(child: Container()),
                        Text('--'),
                        Text('LAST PAYMENT',
                            style: Theme.of(context).textTheme.bodySmall),
                      ]),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('\$ ${debtModel.minimumPayment}',
                        style: Theme.of(context).textTheme.titleMedium),
                    Text('MIN PAYMENT',
                        style: Theme.of(context).textTheme.bodySmall),
                    Expanded(child: Container()),
                    Text('\$ ${debtModel.currentBalance}',
                        style: Theme.of(context).textTheme.titleMedium),
                    Text('CURRENT BALANCE',
                        style: Theme.of(context).textTheme.bodySmall),
                  ])
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.zero,
                  bottomRight: Radius.circular(10.0),
                  topLeft: Radius.zero,
                  bottomLeft: Radius.circular(10.0)),
              color: themeState.primaryColor[600],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Completed: ',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
                Text('0 %',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
