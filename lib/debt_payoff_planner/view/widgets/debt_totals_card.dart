import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../database/database.dart';
import '../../../utils/theme/budget_theme.dart';
import '../../../utils/theme/cubit/theme_cubit.dart';

class DebtTotalsCard extends StatelessWidget {
  final List<Debt> debts;

  const DebtTotalsCard({super.key, required this.debts});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final themeState = context.read<ThemeCubit>().state;
    final currency = NumberFormat.currency(symbol: '\$ ');

    final totalCurrent =
        debts.fold(0.0, (sum, d) => sum + d.currentBalance);
    final totalOriginal =
        debts.fold(0.0, (sum, d) => sum + d.startBalance);
    final activeCount =
        debts.where((d) => d.currentBalance > 0).length;

    final valueStyle = textTheme.titleMedium!.copyWith(
      fontWeight: FontWeight.bold,
      color: themeState.primaryColor[900],
    );

    return Card(
      color: BudgetTheme.isDarkMode(context)
          ? themeState.primaryColor[400]
          : themeState.primaryColor[100],
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(currency.format(totalCurrent), style: valueStyle),
                Text('TOTAL DEBT', style: textTheme.bodySmall),
              ],
            ),
            Column(
              children: [
                Text(currency.format(totalOriginal), style: valueStyle),
                Text('ORIGINAL', style: textTheme.bodySmall),
              ],
            ),
            Column(
              children: [
                Text('$activeCount / ${debts.length}', style: valueStyle),
                Text('ACTIVE', style: textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
