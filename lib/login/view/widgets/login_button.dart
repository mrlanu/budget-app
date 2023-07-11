import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../colors.dart';
import '../../cubit/login_cubit.dart';

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : Container(width: double.infinity,
            child: ElevatedButton(
              key: const Key('loginForm_continue_raisedButton'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor:
                BudgetColors.amber800,
              ),
              onPressed: state.isValid
                  ? () => context.read<LoginCubit>().logInWithCredentials()
                  : null,
              child: const Text('Login', style: TextStyle(fontSize: 20),
              ),
            ));
      },
    );
  }
}
