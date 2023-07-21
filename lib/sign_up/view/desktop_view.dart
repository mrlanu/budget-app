import 'package:budget_app/sign_up/sign_up.dart';
import 'package:flutter/material.dart';

import '../../colors.dart';
import '../../constants/constants.dart';

class DesktopView extends StatelessWidget {
  const DesktopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Log in')),
      body: Container(
        height: h,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/money_back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: w * 0.3,
                    child: Image.asset('assets/images/piggy_logo.png')),
                SizedBox(height: h * 0.03),
                Container(
                  width: w * 0.3,
                  child: Text(
                    textAlign: TextAlign.left,
                    'Do you like saving money ? HomeBudget by Qruto.xyz is a good place to do it. You can track and see your expenses and incomes, planing your budget, sorting the transactions in different way etc.',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 100,
            ),
            Container(
              width: w * 0.3,
              height: h * 0.49,
              decoration: BoxDecoration(
                  color: BudgetColors.teal50,
                  borderRadius: BorderRadius.circular(25)
              ),
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.06),
                  child: Column(
                    children: [
                      EmailInput(),
                      SizedBox(height: h * 0.01),
                      PasswordInput(),
                      SizedBox(height: h * 0.01),
                      ConfirmPasswordInput(),
                      SizedBox(height: h * 0.01),
                      SignUpButton(),
                    ],
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}
