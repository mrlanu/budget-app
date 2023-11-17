import 'package:budget_app/debt_payoff_planner/cubits/strategy_cubit/strategy_cubit.dart';
import 'package:budget_app/debt_payoff_planner/models/debt_payoff_strategy.dart';
import 'package:budget_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../constants/colors.dart';

class PayoffSummary extends StatelessWidget {
  final DebtPayoffStrategy debtPayoffStrategy;

  const PayoffSummary({super.key, required this.debtPayoffStrategy});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<StrategyCubit, StrategyState>(
      builder: (context, state) {
        return Card(
          color: BudgetTheme.isDarkMode(context)
              ? BudgetColors.accentDark
              : BudgetColors.accent,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                        '${DateFormat('MM-dd-yyyy').format(debtPayoffStrategy.debtFreeDate)}',
                        style: textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _getColor(context))),
                    Text('DEBT FREE ON',
                        style: textTheme.bodySmall!
                            .copyWith(color: _getColor(context))),
                  ],
                ),
                Column(
                  children: [
                    Text('${debtPayoffStrategy.totalDuration}',
                        style: textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _getColor(context))),
                    Text('DURATION', style: textTheme.bodySmall!
            .copyWith(color: _getColor(context))),
                  ],
                ),
                Column(
                  children: [
                    Text('\$ ${debtPayoffStrategy.totalInterest}',
                        style: textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _getColor(context))),
                    Text('TOTAL INTEREST', style: textTheme.bodySmall!
            .copyWith(color: _getColor(context))),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getColor(BuildContext context) {
    return BudgetTheme.isDarkMode(context)
        ? BudgetColors.dark
        : BudgetColors.primary;
  }
}
