import 'package:qruto_budget/debt_payoff_planner/cubits/strategy_cubit/strategy_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../utils/theme/budget_theme.dart';
import '../../../utils/theme/cubit/theme_cubit.dart';

class PayoffSummary extends StatelessWidget {
  final DebtPayoffStrategy debtPayoffStrategy;

  const PayoffSummary({super.key, required this.debtPayoffStrategy});

  String _formatDuration(int months) {
    if (months <= 0) return '0 mo';
    if (months < 12) return '$months mo';
    final years = months ~/ 12;
    final rem = months % 12;
    if (rem == 0) return years == 1 ? '1 yr' : '$years yr';
    return '${years}y ${rem}mo';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final themeState = context.read<ThemeCubit>().state;
    final interestFormat = NumberFormat.currency(symbol: '\$ ');

    return Card(
      color: BudgetTheme.isDarkMode(context)
          ? themeState.primaryColor[400]
          : themeState.primaryColor[100],
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  DateFormat('MM-dd-yyyy')
                      .format(debtPayoffStrategy.debtFreeDate),
                  style: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: themeState.primaryColor[900],
                  ),
                ),
                Text('DEBT FREE ON', style: textTheme.bodySmall),
              ],
            ),
            Column(
              children: [
                Text(
                  _formatDuration(debtPayoffStrategy.totalDuration),
                  style: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: themeState.primaryColor[900],
                  ),
                ),
                Text('DURATION', style: textTheme.bodySmall),
              ],
            ),
            Column(
              children: [
                Text(
                  interestFormat.format(debtPayoffStrategy.totalInterest),
                  style: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: themeState.primaryColor[900],
                  ),
                ),
                Text('TOTAL INTEREST', style: textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
