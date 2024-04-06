import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/theme/budget_theme.dart';
import '../../../utils/theme/cubit/theme_cubit.dart';

class DebtFreeCongrats extends StatelessWidget {
  const DebtFreeCongrats({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeCubit>().state;
    return Card(
        margin: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 15),
        color: BudgetTheme.isDarkMode(context)
            ? themeState.primaryColor[400]
            : themeState.primaryColor[100],
        child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 40,
            child: Text(
              'Congratulation ! You are debt free.',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.black,
                  ),
            )));
  }
}
