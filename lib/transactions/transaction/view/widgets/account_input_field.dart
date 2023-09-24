import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../accounts_list/view/accounts_list_page.dart';
import '../../../../budgets/budgets.dart';
import '../../bloc/transaction_bloc.dart';

class AccountInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return DropdownButtonFormField<Account>(
            icon: GestureDetector(
              child: Icon(Icons.edit_note),
              onTap: () {
                Navigator.of(context).push(AccountsListPage.route());
              },
            ),
            items: state.accounts.map((Account account) {
              return DropdownMenuItem(
                value: account,
                //child: Text(account.extendName(state.accountCategories)),
                child: Text(account.name),
              );
            }).toList(),
            onChanged: (newValue) {
              context
                  .read<TransactionBloc>()
                  .add(TransactionAccountChanged(account: newValue));
              //setState(() => selectedValue = newValue);
            },
            value: state.accounts.contains(state.account) ? state.account : null,
            decoration: InputDecoration(
              icon: Icon(
                Icons.account_balance,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              labelText: 'Account',
              //errorText: errorSnapshot.data == 0 ? Localization.of(context).categoryEmpty : null),
            ));
      },
    );
  }
}
