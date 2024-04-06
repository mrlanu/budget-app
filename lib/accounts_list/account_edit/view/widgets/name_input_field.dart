import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/theme/cubit/theme_cubit.dart';
import '../../bloc/account_edit_bloc.dart';

class NameInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeCubit>().state;
    final name = context.select((AccountEditBloc bloc) => bloc.state.name);
    return TextFormField(
        initialValue: name,
        decoration: InputDecoration(
          icon: Icon(
            Icons.notes,
            color: themeState.secondaryColor,
          ),
          border: OutlineInputBorder(),
          labelText: 'Name',
        ),
        onChanged: (name) => context.read<AccountEditBloc>().add(
              AccountNameChanged(name: name),
            ));
  }
}
