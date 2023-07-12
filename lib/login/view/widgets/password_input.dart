import 'package:budget_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/login_cubit.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            icon: Icon(
              Icons.key,
              color: BudgetColors.teal900,
            ),
            border: OutlineInputBorder(),
            labelText: 'Password',
            helperText: '',
            errorText:
            state.password.displayError != null ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}
