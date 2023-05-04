import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SplashPage());
  }

  @override
  Widget build(BuildContext context) {
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
