import 'package:budget_app/transactions/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TransactionListTile extends StatelessWidget {
  final Transaction transaction;
  final DismissDirectionCallback? onDismissed;
  final VoidCallback? onTap;

  const TransactionListTile(
      {Key? key, required this.transaction, this.onTap, this.onDismissed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Dismissible(
      key: Key('transaction_dismissible_${transaction.id}'),
      onDismissed: onDismissed,
      direction: DismissDirection.startToEnd,
      background: Container(
        alignment: Alignment.centerRight,
        color: theme.colorScheme.error,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(
          Icons.delete,
          color: Color(0xAAFFFFFF),
        ),
      ),
      child: ListTile(
        leading: Icon(Icons.clear_all),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\$ ${transaction.amount.toString()}',
              style: TextStyle(
                  fontSize: textTheme.titleLarge!.fontSize,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 30.w,),
            Icon(Icons.chevron_right),
          ],
        ),
        title: Text(
          transaction.subcategoryName!,
          style: TextStyle(fontSize: textTheme.titleLarge!.fontSize),
        ),
        subtitle: Text(
            '${DateFormat('MM-dd-yyyy').format(transaction.date!)} ${transaction.accountName!}'),
        onTap: onTap,
      ),
    );
  }
}
