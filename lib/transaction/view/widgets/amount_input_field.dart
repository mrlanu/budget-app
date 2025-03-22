import 'package:qruto_budget/utils/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/theme/budget_theme.dart';
import '../../transaction.dart';


class AmountInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.read<ThemeCubit>().state;
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
              color: BudgetTheme.isDarkMode(context)
                  ? Colors.white
                  : colors.primaryColor[900],
            ),
            border: OutlineInputBorder(),
            labelText: 'Amount',
            errorText:
            amount.displayError != null ? 'invalid amount' : null,
          ),
        );
  }
}
