import 'package:budget_app/colors.dart';
import 'package:budget_app/home/view/widgets/accounts_summaries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../accounts_list/view/accounts_list_page.dart';
import '../../categories/view/categories_page.dart';
import '../../drawer/main_drawer.dart';
import '../../shared/widgets/paginator/month_paginator.dart';
import '../../transactions/models/transaction_type.dart';
import '../home.dart';

class HomeMobilePage extends StatelessWidget {
  const HomeMobilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeMobileView();
  }
}

class HomeMobileView extends StatelessWidget {
  const HomeMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.status == HomeStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Something went wrong'),
              ),
            );
        }
      },
      child: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
        return SafeArea(
            child: Scaffold(
                backgroundColor: BudgetColors.teal50,
                appBar: AppBar(
                  title: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: state.tab != HomeTab.accounts
                          ? MonthPaginator(
                              onLeft: (date) =>
                                  context.read<HomeCubit>().changeDate(date),
                              onRight: (date) =>
                                  context.read<HomeCubit>().changeDate(date),
                            )
                          : Text('Accounts')),
                  centerTitle: true,
                  actions: <Widget>[
                    IconButton(
                      key: const Key('homePage_logout_iconButton'),
                      icon: const Icon(Icons.create_new_folder_outlined),
                      onPressed: () {
                        switch (state.tab) {
                          case HomeTab.income:
                            Navigator.of(context).push(CategoriesPage.route(
                                transactionType: TransactionType.INCOME));
                            break;
                          case HomeTab.expenses:
                            Navigator.of(context).push(CategoriesPage.route(
                                transactionType: TransactionType.EXPENSE));
                            break;
                          case HomeTab.accounts:
                            Navigator.of(context).push(AccountsListPage.route(
                                homeCubit: context.read<HomeCubit>()));
                            break;
                        }
                      },
                    ),
                  ],
                ),
                drawer: MainDrawer(),
                floatingActionButton:
                    HomeFloatingActionButton(selectedTab: state.tab),
                body: state.status == HomeStatus.loading
                    ? Center(child: CircularProgressIndicator())
                    : state.tab == HomeTab.accounts
                        ? AccountsSummaries()
                        : CategorySummaries(),
                bottomNavigationBar: HomeBottomNavBar(
                    selectedTab: state.tab, sectionsSum: state.sectionsSum)));
      }),
    );
  }
}
