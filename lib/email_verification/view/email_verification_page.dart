import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../utils/theme/budget_theme.dart';
import '../../utils/theme/cubit/theme_cubit.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeCubit>().state;
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'In order to continue verify your email.',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return ElevatedButton(
                  key: const Key('check_email'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: BudgetTheme.isDarkMode(context)
                        ? themeState.secondaryColor
                        : themeState.secondaryColor,
                  ),
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthEmailVerificationRequested());
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
