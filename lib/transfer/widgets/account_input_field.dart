import 'package:budget_app/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../accounts/models/account.dart';
import '../../../../accounts_list/view/accounts_list_page.dart';
import '../bloc/transfer_bloc.dart';

class AccountInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransferBloc, TransferState>(
      builder: (context, state) {
        return DropdownButtonFormField<Account>(
            icon: GestureDetector(
              child: Icon(Icons.edit_note),
              onTap: () {
                Navigator.of(context).push(AccountsListPage.route(
                    homeCubit: context.read<HomeCubit>(),
                    accountCategories: state.accountCategories));
              },
            ),
            items: state.accounts.map((Account account) {
              return DropdownMenuItem(
                value: account,
                child: Text(account.extendName(state.accountCategories)),
              );
            }).toList(),
            onChanged: (newValue) {
              context
                  .read<TransferBloc>()
                  .add(TransferAccountChanged(account: newValue));
              //setState(() => selectedValue = newValue);
            },
            value: state.accounts.contains(state.account) ? state.account : null,
            decoration: InputDecoration(
              icon: Icon(
                Icons.account_balance,
                color: Colors.orangeAccent,
              ),
              border: OutlineInputBorder(),
              labelText: 'Account',
              //errorText: errorSnapshot.data == 0 ? Localization.of(context).categoryEmpty : null),
            ));
      },
    );
  }
}
