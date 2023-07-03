import 'package:budget_app/colors.dart';
import 'package:budget_app/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budget_app/sign_up/sign_up.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          Navigator.of(context).pushNamedAndRemoveUntil(LoginPage.routeName, (route) => false);
        } else if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Sign Up Failure')),
            );
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            FilledCard(height: 500),
            Padding(
              padding: EdgeInsets.all(70.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _EmailInput(),
                  SizedBox(height: 20.h),
                  _PasswordInput(),
                  SizedBox(height: 20.h),
                  _ConfirmPasswordInput(),
                  SizedBox(height: 20.h),
                  _SignUpButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilledCard extends StatelessWidget {

  final int height;

  const FilledCard({super.key, this.height = 700});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: BudgetColors.teal900,
        width: double.infinity,
        height: height.w,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 100.w, vertical: 0),
          child: Image.asset('assets/images/piggy_logo.png'),
        ),
      );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_emailInput_textField'),
          onChanged: (email) => context.read<SignUpCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            icon: Icon(Icons.email, color: Colors.orangeAccent,),
            labelText: 'Email',
            helperText: '',
            border: OutlineInputBorder(),
            errorText:
            state.email.displayError != null ? 'invalid email' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<SignUpCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            icon: Icon(Icons.password, color: Colors.orangeAccent,),
            border: OutlineInputBorder(),
            labelText: 'Password',
            helperText: '',
            errorText:
            state.password.displayError != null ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
      previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_confirmedPasswordInput_textField'),
          onChanged: (confirmPassword) => context
              .read<SignUpCubit>()
              .confirmedPasswordChanged(confirmPassword),
          obscureText: true,
          decoration: InputDecoration(
            icon: Icon(Icons.key, color: Colors.orangeAccent,),
            border: OutlineInputBorder(),
            labelText: 'Confirm password',
            helperText: '',
            errorText: state.confirmedPassword.displayError != null
                ? 'passwords do not match'
                : null,
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
          key: const Key('signUpForm_continue_raisedButton'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: BudgetColors.amber800,
          ),
          onPressed: state.isValid
              ? () => context.read<SignUpCubit>().signUpFormSubmitted()
              : null,
          child: const Text('SIGN UP'),
        );
      },
    );
  }
}
