import 'package:budget_app/debt_payoff_planner/cubits/strategy_cubit/strategy_cubit.dart';
import 'package:budget_app/debt_payoff_planner/models/debt_payoff_strategy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../constants/colors.dart';
import '../../../utils/theme/budget_theme.dart';

class PayoffSummary extends StatelessWidget {
  final DebtPayoffStrategy debtPayoffStrategy;

  const PayoffSummary({super.key, required this.debtPayoffStrategy});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
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
                            color: scheme.primary)),
                    Text('DEBT FREE ON', style: textTheme.bodySmall),
                  ],
                ),
                Column(
                  children: [
                    Text('${debtPayoffStrategy.totalDuration}',
                        style: textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.bold, color: scheme.primary)),
                    Text('DURATION', style: textTheme.bodySmall),
                  ],
                ),
                Column(
                  children: [
                    Text('\$ ${debtPayoffStrategy.totalInterest}',
                        style: textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.bold, color: scheme.primary)),
                    Text('TOTAL INTEREST', style: textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
