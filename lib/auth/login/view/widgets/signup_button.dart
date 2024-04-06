import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/theme/budget_theme.dart';
import '../../../../utils/theme/cubit/theme_cubit.dart';

class SignUpButtonFromLogin extends StatelessWidget {

  SignUpButtonFromLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeCubit>().state;
    return RichText(
      text: TextSpan(
        recognizer: TapGestureRecognizer()
          ..onTap =
              () => context.push('/signup'),
        text: '  Register',
        style: TextStyle(
            color: BudgetTheme.isDarkMode(context)
                ? themeState.secondaryColor
                : themeState.secondaryColor, fontSize: 20),
      ),
    );
  }
}
