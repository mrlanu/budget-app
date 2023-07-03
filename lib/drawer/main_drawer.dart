import 'package:budget_app/colors.dart';
import 'package:budget_app/debt_payoff_planner/view/payoff_page.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: Container(
                  width: double.infinity,
                  child: Image.asset('assets/images/piggy_logo.png',
                      fit: BoxFit.contain))),
          ListTile(
            leading: Icon(Icons.monetization_on_outlined,
                size: 26, color: BudgetColors.teal900),
            title: Text('Budgets',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: BudgetColors.teal900)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.money_outlined,
                size: 26, color: BudgetColors.teal900),
            title: Text('Debt payoff planner',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: BudgetColors.teal900)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, DebtPayoffPage.route());
            },
          ),
          ListTile(
            leading: Icon(Icons.account_balance_outlined,
                size: 26, color: BudgetColors.teal900),
            title: Text('Accounts',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: BudgetColors.teal900)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.category,
                size: 26, color: BudgetColors.teal900),
            title: Text('Categories',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: BudgetColors.teal900)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.settings,
                size: 26, color: BudgetColors.teal900),
            title: Text('Settings',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: BudgetColors.teal900)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
