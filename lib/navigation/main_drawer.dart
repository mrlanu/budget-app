import 'package:budget_app/charts/view/category_chart_page.dart';
import 'package:budget_app/charts/view/trend_chart_page.dart';
import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/debt_payoff_planner/view/payoff_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth.dart';
import '../constants/colors.dart';
import '../summary/view/summary_page.dart';
import '../utils/theme/budget_theme.dart';
import '../utils/theme/cubit/theme_cubit.dart';

class MainDrawer extends StatefulWidget {
  final TabController? tabController;

  const MainDrawer({super.key, this.tabController});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeCubit>().state;
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                themeState.primaryColor[900]!,
                themeState.primaryColor[600]!,
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
                        icon:
                            FaIcon(FontAwesomeIcons.listUl, color: _getColor()),
                        route: SummaryPage.route()),
                    Divider(color: themeState.primaryColor[200]),
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
                    Divider(color: themeState.primaryColor[200]),
                    _buildMenuItem(
                        menuIndex: 3,
                        title: 'Debt payoff planner',
                        icon: FaIcon(FontAwesomeIcons.moneyCheckDollar,
                            color: _getColor()),
                        route: DebtPayoffPage.route()),
                    Divider(color: themeState.primaryColor[200]),
                    _buildMenuItem(
                      menuIndex: 4,
                      title: 'Settings',
                      icon: FaIcon(FontAwesomeIcons.gear, color: _getColor()),
                    ),
                    Divider(color: themeState.primaryColor[200]),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.rightFromBracket,
                          color: _getColor()),
                      title: Text('Log out',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: _getColor())),
                      onTap: () {
                        context
                            .read<AuthBloc>()
                            .add(const AuthLogoutRequested());
                      },
                    ),
                    Divider(color: themeState.primaryColor[200])
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
      Route? route}) {
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
        onTap: route != null
            ? () {
                isDisplayDesktop(context)
                    ? {widget.tabController?.index = menuIndex, setState(() {})}
                    : {
                        Navigator.of(context).pop(),
                        Navigator.of(context).push(route)
                      };
              }
            : () {
                context.pop();
                context.push('/settings');
              });
  }

  Color _getColor() {
    final themeState = context.read<ThemeCubit>().state;
    return BudgetTheme.isDarkMode(context)
        ? BudgetColors.lightContainer
        : themeState.primaryColor[900]!;
  }
}
