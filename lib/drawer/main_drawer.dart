import 'package:budget_app/colors.dart';
import 'package:budget_app/debt_payoff_planner/view/payoff_page.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      backgroundColor: BudgetColors.teal50,
      child: Column(
        children: [
          DrawerHeader(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                BudgetColors.teal600,
                BudgetColors.teal900,
              ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
              child: Row(
                children: [
                  Icon(
                    Icons.monetization_on_outlined,
                    size: 48,
                    color: BudgetColors.amber800,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'My Budget',
                    style: Theme.of(context)
                        .textTheme.headlineLarge!
                        .copyWith(color: BudgetColors.amber800),
                  )
                ],
              )),
          ListTile(
            leading: Icon(Icons.money_outlined, size: 26, color: BudgetColors.teal900,),
            title: Text('Debt payoff planner', style: Theme.of(context)
                .textTheme.titleLarge!
                .copyWith(color: BudgetColors.teal900),),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, DebtPayoffPage.route());
            },
          ),
        ],
      ),
    );
  }
}
