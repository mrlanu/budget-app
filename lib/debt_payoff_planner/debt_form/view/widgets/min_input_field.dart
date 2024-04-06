import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/theme/cubit/theme_cubit.dart';
import '../../debt_form.dart';

class MinInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DebtBloc, DebtState>(
      builder: (context, state) {
        final themeState = context.read<ThemeCubit>().state;
        return TextFormField(
          initialValue: state.minPayment.value,
          onChanged: (payment) => context
              .read<DebtBloc>()
              .add(MinPaymentChanged(payment: payment)),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            icon: Icon(
              Icons.calendar_month,
              color: themeState.secondaryColor,
            ),
            border: OutlineInputBorder(),
            labelText: 'Min payment',
            errorText:
            state.minPayment.displayError != null ? 'invalid amount' : null,
          ),
        );
      },
    );
  }
}
