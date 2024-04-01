import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/colors.dart';
import '../../transaction.dart';


class AmountInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final amount = context.select((TransactionBloc bloc) => bloc.state.amount);
    return TextFormField(
          initialValue: amount.value,
          onChanged: (amount) => context
              .read<TransactionBloc>()
              .add(TransactionAmountChanged(amount: amount)),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            icon: Icon(
              Icons.attach_money,
              color: BudgetColors.accent,
            ),
            border: OutlineInputBorder(),
            labelText: 'Amount',
            errorText:
            amount.displayError != null ? 'invalid amount' : null,
          ),
        );
  }
}
