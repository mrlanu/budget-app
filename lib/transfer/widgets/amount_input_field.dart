import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/theme/budget_theme.dart';
import '../../utils/theme/cubit/theme_cubit.dart';
import '../bloc/transfer_bloc.dart';

class AmountInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeCubit>().state;
    final amount = context.select((TransferBloc bloc) => bloc.state.amount);
    return TextFormField(
          initialValue: amount.value,
          onChanged: (amount) => context
              .read<TransferBloc>()
              .add(TransferAmountChanged(amount: amount)),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            icon: Icon(
              Icons.attach_money,
              color: BudgetTheme.isDarkMode(context)
                  ? Colors.white
                  : colors.primaryColor[900],
            ),
            border: OutlineInputBorder(),
            labelText: 'Amount',
            helperText: '',
            errorText:
            amount.displayError != null ? 'invalid amount' : null,
          ),
        );
  }
}
