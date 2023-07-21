import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../../sign_up/view/sign_up_page.dart';

class SignUpButton extends StatelessWidget {

  SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        recognizer: TapGestureRecognizer()
          ..onTap =
              () => Navigator.of(context).pushNamed(SignUpPage.routeName),
        text: '  Register',
        style: TextStyle(
            color: BudgetColors.teal900, fontSize: 20),
      ),
    );
  }
}
