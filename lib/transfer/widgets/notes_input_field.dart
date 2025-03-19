import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/theme/budget_theme.dart';
import '../../utils/theme/cubit/theme_cubit.dart';
import '../bloc/transfer_bloc.dart';

class NotesInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeCubit>().state;
    final notes = context.select((TransferBloc bloc) => bloc.state.notes);
    return TextFormField(
        initialValue: notes,
        decoration: InputDecoration(
          icon: Icon(
            Icons.notes,
            color: BudgetTheme.isDarkMode(context)
                ? Colors.white
                : colors.primaryColor[900],
          ),
          border: OutlineInputBorder(),
          labelText: 'Notes',
        ),
        onChanged: (notes) => context.read<TransferBloc>().add(
              TransferNotesChanged(notes: notes),
            ));
  }
}
