import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../../utils/theme/budget_theme.dart';
import '../../../../utils/theme/cubit/theme_cubit.dart';
import '../../../auth.dart';

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeCubit>().state;
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? Container(child: const CircularProgressIndicator())
            : Container(width: double.infinity,
            child: ElevatedButton(
              key: const Key('loginForm_continue_raisedButton'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: BudgetTheme.isDarkMode(context)
                    ? themeState.secondaryColor
                    : themeState.secondaryColor,
              ),
              onPressed: state.isValid
                  ? () => context.read<LoginCubit>().logInWithCredentials()
                  : null,
              child: const Text('Login', style: TextStyle(fontSize: 20),
              ),
            ));
      },
    );
  }
}
