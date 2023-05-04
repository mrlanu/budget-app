import 'package:budget_app/colors.dart';
import 'package:budget_app/login/login.dart';
import 'package:budget_app/sign_up/sign_up.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication Failure'),
              ),
            );
        }
      },
      child: Container(
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: size.height * 0.15,
              ),
              Image.asset(
                'assets/images/icon_logo.png',
                height: 80,
              ),
              SizedBox(
                height: 40,
              ),
              _EmailInput(),
              const SizedBox(height: 30),
              _PasswordInput(),
              const SizedBox(height: 60),
              _LoginButton(),
              const SizedBox(height: 30),
              _GoogleLoginButton(),
              const SizedBox(height: 100),
              _SignUpButton()
            ],
          ),
        ),
      ),
    );
  }
}

enum FieldType {
  email,
  password,
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 7,
                    offset: Offset(1, 10),
                    color: Colors.grey.withOpacity(0.3)),
              ]),
          child: TextField(
            key: const Key('loginForm_emailInput_textField'),
            onChanged: (email) =>
                context.read<LoginCubit>().emailChanged(email),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Email',
              prefixIcon: Icon(
                Icons.email,
                color: BudgetColors.inputIconColor
              ),
              focusedBorder: _getBorder(state.email.invalid),
              enabledBorder: _getBorder(state.email.invalid),
              border: _getBorder(state.email.invalid),
            ),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 7,
                    offset: Offset(1, 10),
                    color: Colors.grey.withOpacity(0.3)),
              ]),
          child: TextField(
            key: const Key('loginForm_passwordInput_textField'),
            onChanged: (password) =>
                context.read<LoginCubit>().passwordChanged(password),
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: Icon(
                Icons.key,
                color: BudgetColors.inputIconColor
              ),
              focusedBorder: _getBorder(state.password.invalid),
              enabledBorder: _getBorder(state.password.invalid),
              border: _getBorder(state.password.invalid),
            ),
          ),
        );
      },
    );
  }
}

OutlineInputBorder _getBorder(bool isError) {
  return isError
      ? OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide:
      BorderSide(width: 2.0, color: Color(0xFFFFA000)))
      : OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(width: 1.0, color: Colors.white));
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    final theme = Theme.of(context);
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : GestureDetector(
          onTap: state.status.isValidated
              ? () => context.read<LoginCubit>().logInWithCredentials()
              : null,
          child: Container(
            width: size.width / 2.5,
            height: size.height / 13,
            decoration: BoxDecoration(
                color: state.status.isValidated
                    ? theme.colorScheme.primary
                    : BudgetColors.gray60,
                borderRadius: BorderRadius.circular(30),
                boxShadow: state.status.isValidated
                    ? [
                  BoxShadow(
                      blurRadius: 10,
                      spreadRadius: 7,
                      offset: Offset(1, 10),
                      color: Colors.grey.withOpacity(0.3)),
                ]
                    : null),
            child: Center(
              child: Text('LOGIN',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ),
        );
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<LoginCubit>().logInWithGoogle(),
      child: CircleAvatar(
        minRadius: 25.0,
        backgroundColor: BudgetColors.primaryBackground,
        child: Image.asset('assets/images/google.png', width: 50),
      ),
      /*child: Container(
        child: Image.asset('assets/images/google.png', width: 50),
      ),*/
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Don\'t have an account ?',
        style: TextStyle(color: Colors.grey[500], fontSize: 16),
        children: [
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap =
                  () => Navigator.of(context).pushNamed(SignUpPage.routeName),
            text: '  Create',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
