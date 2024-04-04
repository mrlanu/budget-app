import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../constants/constants.dart';
import '../../../shared/widgets/filled_card.dart';
import '../../auth.dart';

class MobileViewSignup extends StatelessWidget {
  const MobileViewSignup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Log in')),
      body: BlocListener<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state.status.isFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'Sign Up Failure')),
              );
            context.read<SignUpCubit>().resetStatus();
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              FilledCard(height: h * 0.25),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: h * 0.06, horizontal: w * 0.06),
                  child: Column(
                    children: [
                      SignupEmailInput(),
                      SizedBox(height: h * 0.01),
                      SignupPasswordInput(),
                      SizedBox(height: h * 0.01),
                      ConfirmPasswordInput(),
                      SizedBox(height: h * 0.01),
                      SignUpButtonFromLogin(),
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
      );
  }
}
