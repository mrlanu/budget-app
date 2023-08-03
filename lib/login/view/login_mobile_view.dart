import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../constants/constants.dart';
import '../../shared/widgets/filled_card.dart';
import '../login.dart';

class MobileView extends StatelessWidget {
  const MobileView({super.key});

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
              FilledCard(height: h * 0.35),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: h * 0.06, horizontal: w * 0.06),
                  child: Column(
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
                  ),
              ),
            ],
          ),
        ),
      )
      );
  }
}
