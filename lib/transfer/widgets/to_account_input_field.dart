import 'package:budget_app/accounts_list/account_edit/model/account_with_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../utils/theme/cubit/theme_cubit.dart';
import '../bloc/transfer_bloc.dart';

class ToAccountInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    final accounts = context.select((TransferBloc bloc) => bloc.state.accounts);
    final toAccount =
        context.select((TransferBloc bloc) => bloc.state.toAccount);
    final fromAccount =
        context.select((TransferBloc bloc) => bloc.state.fromAccount);
    return DropdownButtonFormField<AccountWithDetails>(
        icon: GestureDetector(
          child: Icon(Icons.edit_note),
          onTap: () {
            context.push('/accounts-list');
          },
        ),
        items: accounts
            .where((fromAcc) => fromAcc.id != fromAccount?.id)
            .map((AccountWithDetails account) {
          return DropdownMenuItem(
            value: account,
            child: Text(account.extendName(
                /*budget.getCategoriesByType(TransactionType.ACCOUNT)*/)),
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
            : accounts.firstWhere((c) => c.id == toAccount.id),
        decoration: InputDecoration(
          icon: Icon(
            Icons.account_balance,
            color: themeState.secondaryColor,
          ),
          border: OutlineInputBorder(),
          labelText: 'To Account',
          //errorText: errorSnapshot.data == 0 ? Localization.of(context).categoryEmpty : null),
        ));
  }
}
