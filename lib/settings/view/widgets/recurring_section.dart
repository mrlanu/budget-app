import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:qruto_budget/database/recurring_transaction_with_detail.dart';
import 'package:qruto_budget/database/tables.dart';
import 'package:qruto_budget/recurring/cubit/recurring_cubit.dart';
import 'package:qruto_budget/recurring/repository/recurring_repository.dart';
import 'package:qruto_budget/transaction/models/transaction_type.dart';

import '../../../utils/theme/budget_theme.dart';
import '../../../utils/theme/cubit/theme_cubit.dart';

class RecurringSection extends StatelessWidget {
  const RecurringSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecurringCubit(
        recurringRepository: context.read<RecurringRepository>(),
      ),
      child: const _RecurringSectionBody(),
    );
  }
}

class _RecurringSectionBody extends StatelessWidget {
  const _RecurringSectionBody();

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    final headerColor = BudgetTheme.isDarkMode(context)
        ? Colors.white
        : themeState.primaryColor[900];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 15.0, bottom: 4.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Active recurring',
              style: TextStyle(fontSize: 44.sp, color: headerColor),
            ),
          ),
        ),
        BlocBuilder<RecurringCubit, RecurringState>(
          builder: (context, state) {
            if (state.status == RecurringStatus.initial) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (state.items.isEmpty) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Card(
                  child: ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.arrowsRotate,
                      color: headerColor,
                      size: 28,
                    ),
                    title: Text(
                      'No recurring transactions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: const Text(
                      'Set Repeat to Weekly or Monthly when adding a transaction',
                    ),
                  ),
                ),
              );
            }
            return Column(
              children: state.items
                  .map((item) => _RecurringTile(item: item))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _RecurringTile extends StatelessWidget {
  const _RecurringTile({required this.item});

  final RecurringTransactionWithDetails item;

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    final iconColor = BudgetTheme.isDarkMode(context)
        ? Colors.white
        : themeState.primaryColor[900];
    final dateFormat = DateFormat.yMMMd();
    final frequencyLabel = item.frequency == RecurringFrequency.weekly
        ? 'Weekly'
        : 'Monthly';
    final typeLabel =
        item.type == TransactionType.INCOME ? 'Income' : 'Expense';

    return Opacity(
      opacity: item.isActive ? 1 : 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Card(
          child: ListTile(
            leading: FaIcon(
              item.type == TransactionType.INCOME
                  ? FontAwesomeIcons.arrowTrendUp
                  : FontAwesomeIcons.arrowTrendDown,
              color: iconColor,
              size: 28,
            ),
            title: Text(
              '\$${item.amount.toStringAsFixed(2)} · $frequencyLabel',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              '${item.category.name} · ${item.fromAccount.name}\n'
              '$typeLabel · Next ${dateFormat.format(item.nextDate)}'
              '${item.isActive ? '' : ' · Paused'}',
            ),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: item.isActive ? 'Pause' : 'Resume',
                  icon: Icon(
                    item.isActive ? Icons.pause_circle_outline : Icons.play_circle_outline,
                  ),
                  onPressed: () => context
                      .read<RecurringCubit>()
                      .toggleActive(item.id, !item.isActive),
                ),
                IconButton(
                  tooltip: 'Delete',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _confirmDelete(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete recurring?'),
        content: const Text(
          'This removes the template only. Transactions already added stay in your budget.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<RecurringCubit>().delete(item.id);
    }
  }
}
