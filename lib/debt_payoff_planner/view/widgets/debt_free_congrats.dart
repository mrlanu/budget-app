import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class DebtFreeCongrats extends StatelessWidget {
  const DebtFreeCongrats({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 15),
      color: BudgetColors.accent,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 40,
        child: Text(
          'Congratulation ! You are debt free.',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: BudgetColors.primary),
        ),
      ),
    );
  }
}
