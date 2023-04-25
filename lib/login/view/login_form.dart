import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budget_app/login/login.dart';
import 'package:budget_app/sign_up/sign_up.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatelessWidget {

  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    print('HELLO');
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
      child: Align(
        alignment: const Alignment(0, -0.5),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 120,
              ),
              SizedBox(height: 40,),
              Card(
                color: Colors.white.withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  side: BorderSide(),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                margin: EdgeInsets.only(left: 10, right: 10),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 30.0, left: 20.0, right: 20.0, bottom: 15.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      _EmailInput(),
                      const SizedBox(height: 8),
                      _PasswordInput(),
                      const SizedBox(height: 8),
                      _LoginButton(),
                      const SizedBox(height: 8),
                      _GoogleLoginButton(),
                      const SizedBox(height: 4),
                      _SignUpButton(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide:
                    BorderSide(color: const Color(0xFF06690A), width: 2.0)),
            labelText: 'email',
            labelStyle:
                TextStyle(fontSize: 18.0, color: const Color(0xFF06690A)),
            helperText: '',
            errorText: state.email.invalid ? 'invalid email' : null,
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
        return TextField(
            key: const Key('loginForm_passwordInput_textField'),
            onChanged: (password) =>
                context.read<LoginCubit>().passwordChanged(password),
            obscureText: true,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide:
                      BorderSide(color: const Color(0xFF06690A), width: 2.0)),
              labelText: 'password',
              labelStyle:
                  TextStyle(fontSize: 18.0, color: const Color(0xFF06690A)),
              helperText: '',
              errorText: state.password.invalid ? 'invalid password' : null,
            ));
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: theme.colorScheme.secondary,
                ),
                onPressed: state.status.isValidated
                    ? () => context.read<LoginCubit>().logInWithCredentials()
                    : null,
                child: const Text('LOGIN'),
              );
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.icon(
      key: const Key('loginForm_googleLogin_raisedButton'),
      label: const Text(
        'SIGN IN WITH GOOGLE',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: theme.colorScheme.secondary,
      ),
      icon: const Icon(FontAwesomeIcons.google, color: Colors.white),
      onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      key: const Key('loginForm_createAccount_flatButton'),
      onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
      child: Text(
        'CREATE ACCOUNT',
        style: TextStyle(color: theme.primaryColor),
      ),
    );
  }
}
