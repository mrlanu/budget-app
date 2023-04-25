import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  static Page<void> page() => const MaterialPage<void>(child: SplashPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Image.asset('assets/images/anim_logo.gif', width: 200,),
        ),
      ),
    );
  }
}
