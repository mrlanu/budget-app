import 'package:budget_app/accounts_list/account_edit/model/account_with_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/theme/cubit/theme_cubit.dart';
import '../../transaction.dart';

class AccountInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    final accounts = context.select((TransactionBloc bloc) => bloc.state.accounts);
    final account =
        context.select((TransactionBloc bloc) => bloc.state.account);
    return DropdownButtonFormField<AccountWithDetails>(
        icon: GestureDetector(
          child: Icon(Icons.edit_note),
          onTap: () {
            context.push('/accounts-list');
          },
        ),
        items: accounts.map((AccountWithDetails account) {
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
        value: account == null
            ? null
            : accounts.firstWhere((a) => a.id == account.id),
        decoration: InputDecoration(
          icon: Icon(
            Icons.account_balance,
            color: themeState.secondaryColor,
          ),
          border: OutlineInputBorder(),
          labelText: 'Account',
          //errorText: errorSnapshot.data == 0 ? Localization.of(context).categoryEmpty : null),
        ));
  }
}
