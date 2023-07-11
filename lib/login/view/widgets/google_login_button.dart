import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../colors.dart';
import '../../cubit/login_cubit.dart';

class GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<LoginCubit>().logInWithGoogle(),
      child: CircleAvatar(
        minRadius: 25.0,
        backgroundColor: BudgetColors.teal50,
        child: Image.asset('assets/images/google.png', width: 50),
      ),
      /*child: Container(
        child: Image.asset('assets/images/google.png', width: 50),
      ),*/
    );
  }
}
