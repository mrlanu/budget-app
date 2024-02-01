import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../sign_up/view/sign_up_page.dart';
import '../../../utils/utils.dart';

class SignUpButton extends StatelessWidget {
  SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        recognizer: TapGestureRecognizer()
          ..onTap = () => Navigator.of(context).push(SignUpPage.route()),
        text: '  Register',
        style: TextStyle(
            color: BudgetTheme.isDarkMode(context)
                ? BudgetColors.primary600
                : BudgetColors.primary,
            fontSize: 20),
      ),
    );
  }
}
