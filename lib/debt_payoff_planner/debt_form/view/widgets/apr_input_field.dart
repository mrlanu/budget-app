import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/theme/cubit/theme_cubit.dart';
import '../../debt_form.dart';

class AprInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DebtBloc, DebtState>(
      builder: (context, state) {
        final themeState = context.read<ThemeCubit>().state;
        return TextFormField(
          initialValue: state.apr.value,
          onChanged: (apr) => context
              .read<DebtBloc>()
              .add(AprChanged(apr: apr)),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            icon: Icon(
              Icons.percent,
              color: themeState.secondaryColor,
            ),
            border: OutlineInputBorder(),
            labelText: 'APR',
            errorText:
            state.apr.displayError != null ? 'invalid amount' : null,
          ),
        );
      },
    );
  }
}
