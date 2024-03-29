import 'package:budget_app/account_edit/bloc/account_edit_bloc.dart';
import 'package:budget_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NameInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountEditBloc, AccountEditState>(
      buildWhen: (previous, current) =>
      previous.name != current.name,
      builder: (context, state) {
        return TextFormField(
          initialValue: state.name,
            decoration: InputDecoration(
              icon: Icon(
                Icons.notes,
                color: BudgetColors.accent,
              ),
              border: OutlineInputBorder(),
              labelText: 'Name',
            ),
            onChanged: (name) => context.read<AccountEditBloc>().add(
              AccountNameChanged(name: name),
            ));
      },
    );
  }
}
