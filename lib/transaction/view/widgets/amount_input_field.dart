import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/colors.dart';
import '../../transaction.dart';


class AmountInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.amount.value,
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
            state.amount.displayError != null ? 'invalid amount' : null,
          ),
        );
      },
    );
  }
}
