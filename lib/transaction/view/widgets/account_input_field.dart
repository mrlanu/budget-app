import 'package:budget_app/accounts_list/account_edit/model/account_with_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/theme/cubit/theme_cubit.dart';
import '../../transaction.dart';

class AccountInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final account =
    context.select((TransactionBloc bloc) => bloc.state.account);
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return DropdownButtonFormField<AccountWithDetails>(
            icon: GestureDetector(
              child: Icon(Icons.edit_note),
              onTap: () {
                context.push('/accounts-list');
              },
            ),
            items: state.accounts.map((AccountWithDetails account) {
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
            },
            value: state.account == null
                ? null
                : state.accounts.firstWhere((a) => a.id == state.account!.id),
            decoration: InputDecoration(
              icon: Icon(
                Icons.account_balance,
                color: context.read<ThemeCubit>().state.secondaryColor,
              ),
              border: OutlineInputBorder(),
              labelText: 'Account',
              //errorText: errorSnapshot.data == 0 ? Localization.of(context).categoryEmpty : null),
            ));
      },
    );
  }
}
