import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../view.dart';

class LoginInputGroup extends StatelessWidget {
  const LoginInputGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EmailInput(),
        SizedBox(height: h * 0.01),
        PasswordInput(),
        SizedBox(height: h * 0.01),
        LoginButton(),
        SizedBox(height: h * 0.01),
        Container(alignment: Alignment.topRight, child: SignUpButton()),
        //GoogleLoginButton(),
      ],
    );
  }
}
