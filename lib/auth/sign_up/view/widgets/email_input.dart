import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/theme/cubit/theme_cubit.dart';
import '../../cubit/sign_up_cubit.dart';

class SignupEmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeCubit>().state;
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_emailInput_textField'),
          onChanged: (email) => context.read<SignUpCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            icon: Icon(Icons.email, color: themeState.secondaryColor),
            labelText: 'Email',
            helperText: '',
            border: OutlineInputBorder(),
            errorText:
            state.email.displayError != null ? 'invalid email' : null,
          ),
        );
      },
    );
  }
}
