import 'package:qruto_budget/debt_payoff_planner/debt_form/bloc/debt_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/theme/cubit/theme_cubit.dart';

class NameInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeCubit>().state;
    return BlocBuilder<DebtBloc, DebtState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return TextFormField(
            initialValue: state.name,
            decoration: InputDecoration(
              icon: Icon(
                Icons.notes,
                color: themeState.secondaryColor,
              ),
              border: OutlineInputBorder(),
              labelText: 'Name',
            ),
            onChanged: (name) =>
                context.read<DebtBloc>().add(NameChanged(name: name)));
      },
    );
  }
}
