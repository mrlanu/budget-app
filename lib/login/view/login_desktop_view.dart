import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../colors.dart';
import '../../constants/constants.dart';
import '../../sign_up/cubit/sign_up_cubit.dart';
import '../../sign_up/sign_up.dart' as signup;
import '../login.dart' as login;

class DesktopView extends StatefulWidget {
  const DesktopView({super.key});

  @override
  State<DesktopView> createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView> {
  late int index;

  @override
  void initState() {
    index = 0;
    super.initState();
  }

  void _changeIndex(int index) {
    setState(() {
      this.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              width: w * 0.04,
            ),
            AnimatedCrossFade(
              duration: Duration(milliseconds: 200),
              firstChild: _loginBuilder(),
              secondChild: _signupBuilder(),
              crossFadeState: index == 0
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
            )
          ],
        ),
      ),
    );
  }

  Widget _loginBuilder() {
    return Container(
      width: w * 0.3,
      height: h * 0.43,
      decoration: BoxDecoration(
          color: BudgetColors.teal50.withOpacity(0.85),
          borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.06),
        child: Column(
          children: [
            login.EmailInput(),
            SizedBox(height: h * 0.01),
            login.PasswordInput(),
            Expanded(child: Container()),
            login.LoginButton(),
            SizedBox(height: h * 0.01),
            Align(
                alignment: Alignment.topRight,
                child: _changedButton(1, 'Register')),
            //GoogleLoginButton(),
          ],
        ),
      ),
    );
  }

  Widget _signupBuilder() {
    return BlocProvider(
      create: (context) => SignUpCubit(
          authenticationRepository: context.read<AuthenticationRepository>()),
      child: Container(
        width: w * 0.3,
        height: h * 0.53,
        decoration: BoxDecoration(
            color: BudgetColors.teal50.withOpacity(0.85),
            borderRadius: BorderRadius.circular(25)),
        child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.06),
            child: Column(
              children: [
                signup.EmailInput(),
                SizedBox(height: h * 0.01),
                signup.PasswordInput(),
                SizedBox(height: h * 0.01),
                signup.ConfirmPasswordInput(),
                SizedBox(height: h * 0.01),
                signup.SignUpButton(),
                SizedBox(
                  height: h * 0.01,
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: _changedButton(0, 'Login'))
              ],
            )),
      ),
    );
  }

  Widget _changedButton(int index, String text) {
    return RichText(
      text: TextSpan(
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            _changeIndex(index);
          },
        text: text,
        style: TextStyle(color: BudgetColors.teal900, fontSize: 20),
      ),
    );
  }
}
