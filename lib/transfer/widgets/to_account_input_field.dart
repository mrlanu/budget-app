import 'package:budget_app/transaction/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../accounts_list/models/account.dart';
import '../bloc/transfer_bloc.dart';

class ToAccountInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final budget = context.select((TransferBloc bloc) => bloc.state.budget);
    final toAccount =
        context.select((TransferBloc bloc) => bloc.state.toAccount);
    final fromAccount =
        context.select((TransferBloc bloc) => bloc.state.fromAccount);
    return DropdownButtonFormField<Account>(
        icon: GestureDetector(
          child: Icon(Icons.edit_note),
          onTap: () {
            context.push('/accounts-list');
          },
        ),
        items: budget.accountList
            .where((fromAcc) => fromAcc.id != fromAccount?.id)
            .map((Account account) {
          return DropdownMenuItem(
            value: account,
            child: Text(account.extendName(
                budget.getCategoriesByType(TransactionType.ACCOUNT))),
          );
        }).toList(),
        onChanged: (newValue) {
          context
              .read<TransferBloc>()
              .add(TransferToAccountChanged(account: newValue));
          //setState(() => selectedValue = newValue);
        },
        value: toAccount == null
            ? null
            : budget.accountList.firstWhere((c) => c.id == toAccount.id),
        decoration: InputDecoration(
          icon: Icon(
            Icons.account_balance,
            color: Colors.orangeAccent,
          ),
          border: OutlineInputBorder(),
          labelText: 'To Account',
          //errorText: errorSnapshot.data == 0 ? Localization.of(context).categoryEmpty : null),
        ));
  }
}
