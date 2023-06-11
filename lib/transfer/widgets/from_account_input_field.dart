import 'package:budget_app/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../accounts/models/account.dart';
import '../../../../accounts_list/view/accounts_list_page.dart';
import '../bloc/transfer_bloc.dart';

class FromAccountInputField extends StatelessWidget {
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
            items: state.accounts
                .where((toAcc) => toAcc.id != state.toAccount?.id)
                .map((Account account) {
              return DropdownMenuItem(
                value: account,
                child: Text(account.extendName(state.accountCategories)),
              );
            }).toList(),
            onChanged: (newValue) {
              context
                  .read<TransferBloc>()
                  .add(TransferFromAccountChanged(account: newValue));
              //setState(() => selectedValue = newValue);
            },
            value: state.accounts.contains(state.fromAccount)
                ? state.fromAccount
                : null,
            decoration: InputDecoration(
              icon: Icon(
                Icons.account_balance,
                color: Colors.orangeAccent,
              ),
              border: OutlineInputBorder(),
              labelText: 'From Account',
              //errorText: errorSnapshot.data == 0 ? Localization.of(context).categoryEmpty : null),
            ));
      },
    );
  }
}
