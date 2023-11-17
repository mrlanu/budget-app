import 'package:budget_app/transactions/models/transaction_tile.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/colors.dart';

class TransactionListTile extends StatelessWidget {
  final TransactionTile transactionTile;
  final DismissDirectionCallback? onDismissed;
  final VoidCallback? onTap;

  const TransactionListTile(
      {Key? key, required this.transactionTile, this.onTap, this.onDismissed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Dismissible(
      key: Key('transaction_dismissible_${transactionTile.id}'),
      onDismissed: onDismissed,
      direction: DismissDirection.startToEnd,
      background: Container(
        color: BudgetColors.error,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(
          Icons.delete,
          color: Color(0xAAFFFFFF),
        ),
      ),
      child: ListTile(
        leading: Icon(
          Icons.clear_all,
          color: BudgetColors.darkerGrey,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\$ ${transactionTile.amount.toString()}',
              style: TextStyle(
                  color: (transactionTile.type == TransactionType.EXPENSE ||
                          transactionTile.title == 'Transfer out')
                      ? BudgetColors.error
                      : BudgetColors.primary,
                  fontSize: textTheme.titleLarge!.fontSize,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.chevron_right),
          ],
        ),
        title: Text(
          transactionTile.title,
          style: TextStyle(
            fontSize: textTheme.titleLarge!.fontSize,
            color: transactionTile.type == TransactionType.EXPENSE
                ? BudgetColors.primary
                : BudgetColors.primary,
          ),
        ),
        subtitle: Text(
          '${DateFormat('MM-dd-yyyy').format(transactionTile.dateTime)} ${transactionTile.subtitle}',
          style: TextStyle(color: BudgetColors.primary),
        ),
        isThreeLine: false,
        onTap: onTap,
      ),
    );
  }
}
