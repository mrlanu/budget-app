import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/theme/cubit/theme_cubit.dart';
import '../../cubit/sign_up_cubit.dart';

class SignupPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeCubit>().state;
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<SignUpCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            icon: Icon(Icons.key, color: themeState.secondaryColor),
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
