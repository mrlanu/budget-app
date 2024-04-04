import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/theme/cubit/theme_cubit.dart';
import '../../bloc/account_edit_bloc.dart';

class BalanceInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeCubit>().state;
    final balance = context.select((AccountEditBloc bloc) => bloc.state.balance);
    return TextFormField(
          initialValue: balance.value,
          onChanged: (balance) => context
              .read<AccountEditBloc>()
              .add(AccountBalanceChanged(balance: balance)),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            icon: Icon(
              Icons.attach_money,
              color: themeState.secondaryColor,
            ),
            border: OutlineInputBorder(),
            labelText: 'Balance',
            helperText: '',
            errorText:
            balance.displayError != null ? 'invalid balance' : null,
          ),
        );
  }
}
