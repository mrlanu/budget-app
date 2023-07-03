import 'package:budget_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SplashPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BudgetColors.teal900,
      body: Center(
        child: Container(
          width: 500.w,
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
  }
}
