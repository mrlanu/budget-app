import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../accounts_list/models/account.dart';
import '../../../utils/theme/cubit/theme_cubit.dart';
import '../../transaction.dart';

class AccountInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    final budget = context.select((TransactionBloc bloc) => bloc.state.budget);
    final account =
        context.select((TransactionBloc bloc) => bloc.state.account);
    return DropdownButtonFormField<Account>(
        icon: GestureDetector(
          child: Icon(Icons.edit_note),
          onTap: () {
            context.push('/accounts-list');
          },
        ),
        items: budget.accountList.map((Account account) {
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
            : budget.accountList.firstWhere((a) => a.id == account.id),
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
