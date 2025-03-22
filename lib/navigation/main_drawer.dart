import 'package:qruto_budget/database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../accounts_list/repository/account_repository.dart';
import '../categories/repository/category_repository.dart';
import '../constants/colors.dart';
import '../database/migration.dart';
import '../transaction/repository/transaction_repository.dart';
import '../utils/theme/budget_theme.dart';
import '../utils/theme/cubit/theme_cubit.dart';

class MainDrawer extends StatefulWidget {
  final TabController? tabController;

  const MainDrawer({super.key, this.tabController});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {

  late int count;


  @override
  void initState() {
    super.initState();
    count = 0;
  }

  void _migration() async {
    if(mounted){
      setState(() {
        count++;
      });
    }
    if(count == 10){
      final db = context.read<AppDatabase>();
      await db.truncateTables();
      fetchOldData(
            transactionRepository:
            context.read<TransactionRepository>(),
            accountRepository:
            context.read<AccountRepository>(),
            categoryRepository:
            context.read<CategoryRepository>());
      count = 0;
      final messenger = ScaffoldMessenger.of(context);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(duration: Duration(seconds: 5),
            backgroundColor: BudgetColors.warning,
            content: Text('Fetching data...',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20)),
          ),
        );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeCubit>().state;
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
              child: GestureDetector(
                onTap: _migration,
                child: Container(
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/piggy_bank.png',
                    )),
              )),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    _buildMenuItem(
                        menuIndex: 1,
                        title: 'Summary',
                        icon:
                            FaIcon(FontAwesomeIcons.listUl, color: _getColor()),
                        routeName: 'summary'),
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
                                routeName: 'trend')),
                        Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: _buildMenuItem(
                                menuIndex: 2,
                                title: 'Sum by Category',
                                icon: null,
                                routeName: 'category-trend')),
                      ],
                    ),
                    Divider(color: themeState.primaryColor[200]),
                    _buildMenuItem(
                        menuIndex: 3,
                        title: 'Debt payoff planner',
                        icon: FaIcon(FontAwesomeIcons.moneyCheckDollar,
                            color: _getColor()),
                        routeName: 'debt-payoff'),
                    Divider(color: themeState.primaryColor[200]),
                    _buildMenuItem(
                        menuIndex: 4,
                        title: 'Settings',
                        icon: FaIcon(FontAwesomeIcons.gear, color: _getColor()),
                        routeName: 'settings'),
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
      required String routeName}) {
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
          context.pop();
          context.push('/$routeName');
        });
  }

  Color _getColor() {
    final themeState = context.read<ThemeCubit>().state;
    return BudgetTheme.isDarkMode(context)
        ? BudgetColors.lightContainer
        : themeState.primaryColor[900]!;
  }
}
