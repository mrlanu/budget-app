import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/theme/cubit/theme_cubit.dart';
import '../../debt_form.dart';

class BalanceInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeCubit>().state;
    return BlocBuilder<DebtBloc, DebtState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.balance.value,
          onChanged: (balance) => context
              .read<DebtBloc>()
              .add(BalanceChanged(balance: balance)),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            icon: Icon(
              Icons.attach_money,
              color: themeState.secondaryColor,
            ),
            border: OutlineInputBorder(),
            labelText: 'Balance',
            errorText:
            state.balance.displayError != null ? 'invalid amount' : null,
          ),
        );
      },
    );
  }
}
