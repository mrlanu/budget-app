import 'package:budget_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../accounts_list/view/accounts_list_page.dart';
import '../../categories/view/categories_page.dart';
import '../../drawer/main_drawer.dart';
import '../../shared/widgets/month_paginator.dart';
import '../../transaction/models/transaction_type.dart';
import '../home.dart';

class HomeMobilePage extends StatelessWidget {
  const HomeMobilePage({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return SafeArea(
            child: Scaffold(
                backgroundColor: BudgetColors.teal50,
                appBar: AppBar(
                  title: MonthPaginator(
                    onLeft: (date) =>
                        context.read<HomeCubit>().changeDate(date),
                    onRight: (date) =>
                        context.read<HomeCubit>().changeDate(date),
                  ),
                  centerTitle: true,
                  actions: <Widget>[
                    /*IconButton(
                      key: const Key('homePage_deleteBudget'),
                      icon: const Icon(Icons.delete_forever),
                      onPressed: () {
                        context.read<HomeCubit>().deleteBudget();
                      },
                    ),*/
                    IconButton(
                      key: const Key('homePage_logout_iconButton'),
                      icon: const Icon(Icons.create_new_folder_outlined),
                      onPressed: () {
                        switch (navigationShell.currentIndex) {
                          case 0:
                            Navigator.of(context).push(CategoriesPage.route(
                                transactionType: TransactionType.INCOME));
                            break;
                          case 1:
                            Navigator.of(context).push(CategoriesPage.route(
                                transactionType: TransactionType.EXPENSE));
                            break;
                          case 2:
                            Navigator.of(context)
                                .push(AccountsListPage.route());
                            break;
                        }
                      },
                    ),
                  ],
                ),
                drawer: MainDrawer(),
                body: navigationShell,
                floatingActionButton: HomeFloatingActionButton(
                    selectedTab: HomeTab.values.firstWhere((element) =>
                        element.index == navigationShell.currentIndex)),
                bottomNavigationBar:
                    HomeBottomNavBar(navigationShell: navigationShell)));
      },
    );
  }
}
