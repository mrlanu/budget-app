import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../constants/constants.dart';
import '../../sign_up/view/sign_up_form.dart';
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
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              FilledCard(),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: h * 0.06, horizontal: w * 0.06),
                  child: LoginInputGroup()
              ),
            ],
          ),
        ),
      )
      );
  }
}
