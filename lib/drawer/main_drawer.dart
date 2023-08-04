import 'package:budget_app/charts/view/chart_page.dart';
import 'package:budget_app/colors.dart';
import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/debt_payoff_planner/view/payoff_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../app/bloc/app_bloc.dart';
import '../home/view/home_page.dart';
import '../summary/view/summary_page.dart';

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
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    ListTile(
                      tileColor:
                      widget.tabController?.index == 0 ? BudgetColors.teal100 : null,
                      leading:
                      FaIcon(FontAwesomeIcons.coins, color: BudgetColors.teal900),
                      title: Text('Budgets',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: BudgetColors.teal900)),
                      onTap: () {
                        isDisplayDesktop(context)
                            ? {
                          widget.tabController?.index = 0,
                          setState(
                                () {},
                          )
                        }
                            : Navigator.of(context).pushNamedAndRemoveUntil<void>(
                          HomePage.routeName,
                              (route) => false,
                        );
                      },
                    ),
                    Divider(color: BudgetColors.teal900),
                    ListTile(
                      tileColor:
                      widget.tabController?.index == 1 ? BudgetColors.teal100 : null,
                      leading: FaIcon(
                        FontAwesomeIcons.listUl,
                        color: BudgetColors.teal900,
                      ),
                      title: Text('Summary',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: BudgetColors.teal900)),
                      onTap: () {
                        isDisplayDesktop(context)
                            ? {
                          widget.tabController?.index = 1,
                          setState(() {}),
                        }
                            : {
                          Navigator.pop(context),
                          Navigator.of(context).push(SummaryPage.route())
                        };
                      },
                    ),
                    Divider(color: BudgetColors.teal900),
                    ListTile(
                      tileColor:
                      widget.tabController?.index == 2 ? BudgetColors.teal100 : null,
                      leading: FaIcon(FontAwesomeIcons.chartSimple,
                          color: BudgetColors.teal900),
                      title: Text('Trend',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: BudgetColors.teal900)),
                      onTap: () {
                        isDisplayDesktop(context)
                            ? {
                          widget.tabController?.index = 2,
                          setState(() {}),
                        }
                            : {
                          Navigator.pop(context),
                          Navigator.of(context).push(ChartPage.route())
                        };
                      },
                    ),
                    Divider(color: BudgetColors.teal900),
                    ListTile(
                      tileColor:
                      widget.tabController?.index == 3 ? BudgetColors.teal100 : null,
                      leading: FaIcon(FontAwesomeIcons.moneyCheckDollar,
                          color: BudgetColors.teal900),
                      title: Text('Debt payoff planner',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: BudgetColors.teal900)),
                      onTap: () {
                        isDisplayDesktop(context)
                            ? {
                          widget.tabController?.index = 3,
                          setState(() {}),
                        }
                            : {
                          Navigator.pop(context),
                          Navigator.push(context, DebtPayoffPage.route())
                        };
                      },
                    ),
                    Divider(color: BudgetColors.teal900),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.gear, color: BudgetColors.teal900),
                      title: Text('Settings',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: BudgetColors.teal900)),
                      onTap: () {},
                    ),
                    Divider(color: BudgetColors.teal900),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.rightFromBracket, color: BudgetColors.teal900),
                      title: Text('Log out',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: BudgetColors.teal900)),
                      onTap: () {
                        context.read<AppBloc>().add(const AppLogoutRequested());
                      },
                    ),
                    Divider(color: BudgetColors.teal900)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
