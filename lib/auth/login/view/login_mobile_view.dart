import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../constants/constants.dart';
import '../login.dart';

class MobileViewLogin extends StatelessWidget {
  const MobileViewLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication Failure'),
              ),
            );
          context.read<LoginCubit>().resetStatus();
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50,),
            Image.asset('assets/images/piggy_bank.png', width: 300, height: 300,),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: h * 0.04, horizontal: w * 0.06),
              child: Column(
                children: [
                  EmailInput(),
                  SizedBox(height: h * 0.01),
                  PasswordInput(),
                  SizedBox(height: h * 0.01),
                  LoginButton(),
                  SizedBox(height: h * 0.01),
                  Container(
                      alignment: Alignment.topRight,
                      child: SignUpButtonFromLogin()),
                  //GoogleLoginButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
