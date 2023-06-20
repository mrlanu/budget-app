import 'package:budget_app/transactions/models/transaction_tile.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

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
    final textTheme = Theme.of(context).textTheme;
    return Dismissible(
      key: Key('transaction_dismissible_${transactionTile.id}'),
      onDismissed: onDismissed,
      direction: DismissDirection.startToEnd,
      background: Container(
        //alignment: Alignment.centerRight,
        color: theme.error,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(
          Icons.delete,
          color: Color(0xAAFFFFFF),
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
        elevation: Theme.of(context).cardTheme.elevation,
        child: ClipPath(
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                    color: (transactionTile.type == TransactionType.EXPENSE)
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.tertiary,
                    width: 20.w),
              ),
            ),
            child: ListTile(
              leading: Icon(Icons.clear_all),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$ ${transactionTile.amount.toString()}',
                    style: TextStyle(
                        color:
                            (transactionTile.type == TransactionType.EXPENSE ||
                                    transactionTile.title ==
                                        'Transfer out')
                                ? theme.error
                                : theme.tertiary,
                        fontSize: textTheme.titleLarge!.fontSize,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 30.w,
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
              title: Text(
                transactionTile.title,
                style: TextStyle(
                  fontSize: textTheme.titleLarge!.fontSize,
                  color: transactionTile.type == TransactionType.EXPENSE
                      ? theme.onErrorContainer
                      : theme.onTertiaryContainer,
                ),
              ),
              subtitle: Text(
                  '${DateFormat('MM-dd-yyyy').format(transactionTile.dateTime)} ${transactionTile.subtitle}'),
              isThreeLine: false,
              onTap: onTap,
            ),
          ),
        ),
      ),
    );
  }
}
