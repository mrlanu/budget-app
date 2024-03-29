import 'package:budget_app/charts/view/category_chart_page.dart';
import 'package:budget_app/charts/view/trend_chart_page.dart';
import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/debt_payoff_planner/view/payoff_page.dart';
import 'package:budget_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../app/bloc/app_bloc.dart';
import '../constants/colors.dart';
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
      child: Column(
        children: [
          DrawerHeader(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                BudgetColors.primary600,
                BudgetColors.primary,
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
                    /*_buildMenuItem(
                        menuIndex: 0,
                        title: 'Budgets',
                        icon: FaIcon(FontAwesomeIcons.coins,
                            color: BudgetColors.teal900),
                        route: HomePage.route()),
                    Divider(color: BudgetColors.teal900),*/
                    _buildMenuItem(
                        menuIndex: 1,
                        title: 'Summary',
                        icon: FaIcon(FontAwesomeIcons.listUl,
                            color: _getColor()),
                        route: SummaryPage.route()),
                    Divider(color: _getColor()),
                    ExpansionTile(
                      shape: Border.all(color: Colors.transparent),
                      title: Row(
                        children: [
                          FaIcon(FontAwesomeIcons.chartSimple,
                              color: _getColor()),
                          SizedBox(width: 20),
                          Text('Charts',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: _getColor())),
                        ],
                      ),
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: _buildMenuItem(
                                menuIndex: 2,
                                title: 'Trend',
                                icon: null,
                                route: TrendChartPage.route())),
                        Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: _buildMenuItem(
                                menuIndex: 2,
                                title: 'Sum by Category',
                                icon: null,
                                route: CategoryChartPage.route())),
                      ],
                    ),
                    Divider(color: _getColor()),
                    _buildMenuItem(
                        menuIndex: 3,
                        title: 'Debt payoff planner',
                        icon: FaIcon(FontAwesomeIcons.moneyCheckDollar,
                            color: _getColor()),
                        route: DebtPayoffPage.route()),
                    /*Divider(color: BudgetColors.teal900),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.gear,
                          color: BudgetColors.teal900),
                      title: Text('Settings',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: BudgetColors.teal900)),
                      onTap: () {},
                    ),*/
                    Divider(color: _getColor()),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.rightFromBracket,
                          color: _getColor()),
                      title: Text('Log out',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: _getColor())),
                      onTap: () {
                        context.read<AppBloc>().add(const AppLogoutRequested());
                      },
                    ),
                    Divider(color: _getColor())
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  ListTile _buildMenuItem(
      {required int menuIndex,
      required String title,
      required Widget? icon,
      required Route route}) {
    return ListTile(
      tileColor: widget.tabController?.index == menuIndex
          ? BudgetColors.light
          : null,
      leading: icon,
      title: Text(title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: _getColor())),
      onTap: () {
        isDisplayDesktop(context)
            ? {widget.tabController?.index = menuIndex, setState(() {})}
            : {Navigator.of(context).pop(), Navigator.of(context).push(route)};
      },
    );
  }

  Color _getColor() => BudgetTheme.isDarkMode(context)
      ? BudgetColors.lightContainer
      : BudgetColors.primary;
}
