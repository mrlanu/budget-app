import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budget_app/login/login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    print('G E N E R A T E D');
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              /*gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(14, 40, 0, 1.0).withOpacity(0.5),
                  Color.fromRGBO(14, 40, 0, 1.0).withOpacity(1.0),
                ],*/
      color: Color.fromRGBO(17, 17, 31, 1),
                /*begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                stops: [0, 1],
              ),*/
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: BlocProvider(
              create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
              child: const LoginForm(),
            ),
          ),
        ],
      ),
    );
  }
}
