import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth.dart';

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
            return MobileViewLogin();
          }
          return Scaffold(
            body: Center(
              child: Text(
                  'Just mobile view currently supported. '
                      'Please lunch me from the any mobile browser.', style: Theme.of(context).textTheme.titleLarge,),
            ),
          ); //DesktopViewLogin();
        },
      ),
    );
  }
}
