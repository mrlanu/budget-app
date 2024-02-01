import 'package:authentication_repository/authentication_repository.dart';
import 'package:budget_app/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  static const routeName = '/signup';

  static Route<void> route() {
    return MaterialPageRoute(builder: (context) {
      return SignUpPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpCubit(context.read<AuthenticationRepository>()),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 1100) {
            return MobileView();
          }
          return DesktopView();
        },
      ),
    );
  }
}
