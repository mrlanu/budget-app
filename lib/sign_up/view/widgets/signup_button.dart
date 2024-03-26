import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../constants/colors.dart';
import '../../../utils/theme/budget_theme.dart';
import '../../cubit/sign_up_cubit.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : Container(
                width: double.infinity,
                child: ElevatedButton(
                    key: const Key('signUpForm_continue_raisedButton'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: BudgetColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: BudgetTheme.isDarkMode(context)
                          ? BudgetColors.accentDark
                          : BudgetColors.accent,
                    ),
                    onPressed: state.isValid
                        ? () =>
                            context.read<SignUpCubit>().signUpFormSubmitted().then((value) {
                              Navigator.of(context).pop();
                            })
                        : null,
                    child: const Text('Register',
                        style: TextStyle(fontSize: 20))));
      },
    );
  }
}
