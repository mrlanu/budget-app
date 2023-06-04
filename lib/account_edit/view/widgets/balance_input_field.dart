import 'package:budget_app/account_edit/bloc/account_edit_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BalanceInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountEditBloc, AccountEditState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.balance.value,
          onChanged: (balance) => context
              .read<AccountEditBloc>()
              .add(AccountBalanceChanged(balance: balance)),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            icon: Icon(
              Icons.attach_money,
              color: Colors.orangeAccent,
            ),
            border: OutlineInputBorder(),
            labelText: 'Balance',
            helperText: '',
            errorText:
            state.balance.displayError != null ? 'invalid balance' : null,
          ),
        );
      },
    );
  }
}
