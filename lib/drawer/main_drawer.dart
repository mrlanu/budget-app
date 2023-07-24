import 'package:budget_app/charts/view/chart_page.dart';
import 'package:budget_app/colors.dart';
import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/debt_payoff_planner/view/payoff_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/bloc/app_bloc.dart';
import '../home/view/home_page.dart';

class MainDrawer extends StatefulWidget {
  final TabController? tabController;

  const MainDrawer({super.key, this.tabController});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
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
            tileColor:
                widget.tabController?.index == 0 ? BudgetColors.teal100 : null,
            leading: Icon(Icons.monetization_on_outlined,
                size: 26, color: BudgetColors.teal900),
            title: Text('Home',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: BudgetColors.teal900)),
            onTap: () {
              isDisplayDesktop(context)
                  ? {widget.tabController?.index = 0, setState(() {},)}
                  : Navigator.of(context).pushNamedAndRemoveUntil<void>(
                      HomePage.routeName,
                      (route) => false,
                    );
            },
          ),
          ListTile(
            tileColor:
                widget.tabController?.index == 1 ? BudgetColors.teal100 : null,
            leading:
                Icon(Icons.bar_chart, size: 26, color: BudgetColors.teal900),
            title: Text('Trend',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: BudgetColors.teal900)),
            onTap: () {
              isDisplayDesktop(context)
                  ? {widget.tabController?.index = 1, setState(() {}),}
                  : {
                      Navigator.pop(context),
                      Navigator.of(context).push(ChartPage.route())
                    };
            },
          ),
          ListTile(
            tileColor:
            widget.tabController?.index == 2 ? BudgetColors.teal100 : null,
            leading: Icon(Icons.money_outlined,
                size: 26, color: BudgetColors.teal900),
            title: Text('Debt payoff planner',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: BudgetColors.teal900)),
            onTap: () {
              isDisplayDesktop(context)
                  ? {widget.tabController?.index = 2, setState(() {}),}
                  : {
                      Navigator.pop(context),
                      Navigator.push(context, DebtPayoffPage.route())
                    };
            },
          ),
          ListTile(
            leading:
                Icon(Icons.settings, size: 26, color: BudgetColors.teal900),
            title: Text('Settings',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: BudgetColors.teal900)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout, size: 26, color: BudgetColors.teal900),
            title: Text('Log out',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: BudgetColors.teal900)),
            onTap: () {
              context.read<AppBloc>().add(const AppLogoutRequested());
            },
          ),
        ],
      ),
    );
  }
}
