import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../debt_form.dart';

class BalanceInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              color: Colors.orangeAccent,
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
