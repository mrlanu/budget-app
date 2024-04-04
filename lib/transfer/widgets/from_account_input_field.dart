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
            .where((toAcc) => toAcc.id != toAccount?.id)
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
              .add(TransferFromAccountChanged(account: newValue));
          //setState(() => selectedValue = newValue);
        },
        value: fromAccount == null
            ? null
            : budget.accountList.firstWhere((c) => c.id == fromAccount.id),
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
