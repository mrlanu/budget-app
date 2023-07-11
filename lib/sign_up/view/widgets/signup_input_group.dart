import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/sign_up/sign_up.dart';
import 'package:flutter/material.dart';

class SignupInputGroup extends StatelessWidget {
  const SignupInputGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EmailInput(),
        SizedBox(height: h * 0.01),
        PasswordInput(),
        SizedBox(height: h * 0.01),
        ConfirmPasswordInput(),
        SizedBox(height: h * 0.01),
        SignUpButton(),
      ],
    );
  }
}
