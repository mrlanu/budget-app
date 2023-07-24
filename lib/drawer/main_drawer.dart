import 'package:budget_app/charts/view/chart_page.dart';
import 'package:budget_app/colors.dart';
import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/debt_payoff_planner/view/payoff_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/bloc/app_bloc.dart';
import '../home/view/home_page.dart';

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
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil<void>(
                HomePage.routeName,
                    (route) => false,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.bar_chart,
                size: 26, color: BudgetColors.teal900),
            title: Text('Trend',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: BudgetColors.teal900)),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(ChartPage.route());
            },
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
              if(isDisplayDesktop(context)){
                Navigator.of(context).pushAndRemoveUntil(
                  DebtPayoffPage.route(),
                      (route) => false,
                );
              }
              Navigator.pop(context);
              Navigator.push(context, DebtPayoffPage.route());
            },
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
          ListTile(
            leading: Icon(Icons.logout,
                size: 26, color: BudgetColors.teal900),
            title: Text('Log out',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: BudgetColors.teal900)),
            onTap: () {context.read<AppBloc>().add(const AppLogoutRequested());},
          ),
        ],
      ),
    );
  }
}
