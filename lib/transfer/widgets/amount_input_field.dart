import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/transfer_bloc.dart';

class AmountInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransferBloc, TransferState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.amount.value,
          onChanged: (amount) => context
              .read<TransferBloc>()
              .add(TransferAmountChanged(amount: amount)),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            icon: Icon(
              Icons.attach_money,
              color: Colors.orangeAccent,
            ),
            border: OutlineInputBorder(),
            labelText: 'Amount',
            helperText: '',
            errorText:
            state.amount.displayError != null ? 'invalid amount' : null,
          ),
        );
      },
    );
  }
}
