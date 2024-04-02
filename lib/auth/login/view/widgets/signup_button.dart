import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/colors.dart';
import '../../../../utils/theme/budget_theme.dart';

class SignUpButtonFromLogin extends StatelessWidget {

  SignUpButtonFromLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        recognizer: TapGestureRecognizer()
          ..onTap =
              () => context.push('/signup'),
        text: '  Register',
        style: TextStyle(
            color: BudgetTheme.isDarkMode(context)
                ? BudgetColors.primary600
                : BudgetColors.primary, fontSize: 20),
      ),
    );
  }
}
