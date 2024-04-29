import 'package:budget_app/transaction/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../accounts_list/models/account.dart';
import '../../utils/theme/cubit/theme_cubit.dart';
import '../bloc/transfer_bloc.dart';

class FromAccountInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    final accounts = context.select((TransferBloc bloc) => bloc.state.accounts);
    final categories = context.select((TransferBloc bloc) => bloc.state.categories);
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
        items: accounts
            .where((toAcc) => toAcc.id != toAccount?.id)
            .map((Account account) {
          return DropdownMenuItem(
            value: account,
            child: Text(account.extendName(
                categories.where((c) => c.type == TransactionType.ACCOUNT).toList())),
          );
        }).toList(),
        onChanged: (newValue) {
          context
              .read<TransferBloc>()
              .add(TransferFromAccountChanged(account: newValue));
          //setState(() => selectedValue = newValue);
        },
        value: fromAccount == null
            ? null
            : accounts.firstWhere((c) => c.id == fromAccount.id),
        decoration: InputDecoration(
          icon: Icon(
            Icons.account_balance,
            color: themeState.secondaryColor,
          ),
          border: OutlineInputBorder(),
          labelText: 'From Account',
          //errorText: errorSnapshot.data == 0 ? Localization.of(context).categoryEmpty : null),
        ));
  }
}
