import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../constants/colors.dart';
import '../../../transaction/transaction.dart';

class TransactionListTile extends StatelessWidget {
  final TransactionTile transactionTile;
  final DismissDirectionCallback? onDismissed;
  final VoidCallback? onTap;

  const TransactionListTile(
      {Key? key, required this.transactionTile, this.onTap, this.onDismissed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Dismissible(
      key: Key('transaction_dismissible_${transactionTile.id}'),
      onDismissed: onDismissed,
      direction: DismissDirection.startToEnd,
      background: Container(
        color: theme.error,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(
          Icons.delete,
          color: Color(0xAAFFFFFF),
        ),
      ),
      child: ListTile(
        leading: Icon(
          Icons.clear_all,
          color: Colors.black87,
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
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.black87,
            ),
          ],
        ),
        title: Text(
          transactionTile.title,
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          '${DateFormat('MM-dd-yyyy').format(transactionTile.dateTime)} ${transactionTile.subtitle}',
          style: TextStyle(color: Colors.black87, fontSize: 18.sp,),
        ),
        isThreeLine: false,
        onTap: onTap,
      ),
    );
  }
}
