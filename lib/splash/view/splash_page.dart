import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/bloc/app_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  static Page<void> page() => const MaterialPage<void>(child: SplashPage());

  @override
  Widget build(BuildContext context) {
    context.select((AppBloc bloc) => bloc.add(SplashStart()));
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 17, 31, 1),
      body: Center(
        child: Container(
          child: Image.asset('assets/images/anim_logo.gif',),
        ),
      ),
    );
  }
}
