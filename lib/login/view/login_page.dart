import 'package:authentication_repository/authentication_repository.dart';
import 'package:budget_app/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const routeName = '/login';

  static Page<void> page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(context.read<AuthenticationRepository>()),
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

