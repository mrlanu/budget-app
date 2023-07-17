import 'package:budget_app/accounts/models/account.dart';
import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../../transactions/models/transactions_view_filter.dart';
import '../../../transactions/view/transactions_list.dart';

class AccountsSummaries extends StatefulWidget {
  final List<Account> accountList;
  final Key key;

  AccountsSummaries({required this.accountList, required this.key})
      : super(key: key);

  @override
  State<AccountsSummaries> createState() => _AccountsSummariesState();
}

class _AccountsSummariesState extends State<AccountsSummaries> {
  late final List<Account> _accountList;

  @override
  void initState() {
    super.initState();
    _accountList = widget.accountList;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
        child: ExpansionPanelList(
          dividerColor: BudgetColors.teal900,
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _accountList[index] =
                  _accountList[index].copyWith(isExpanded: !isExpanded);
            });
          },
          children: _accountList.map<ExpansionPanel>((acc) {
            return ExpansionPanel(
                canTapOnHeader: true,
                backgroundColor: BudgetColors.teal100,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    leading: Icon(Icons.account_balance_outlined, color: scheme.primary),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$ ${acc.balance.toString()}',
                          style: TextStyle(
                              fontSize: textTheme.titleLarge!.fontSize,
                              fontWeight: FontWeight.bold,
                              color: scheme.primary),
                        ),
                      ],
                    ),
                    title: Text(
                      acc.name,
                      style: TextStyle(
                          fontSize: textTheme.titleLarge!.fontSize,
                          fontWeight: FontWeight.bold,
                          color: scheme.primary),
                    ),
                  );
                },
                body: TransactionsList(
                    filter: TransactionsViewFilter(
                        type: TransactionsViewFilterTypes.accountId,
                        filterId: acc.id)),
                isExpanded: acc.isExpanded);
          }).toList(),
        ));
  }
}
