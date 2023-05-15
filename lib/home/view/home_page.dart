import 'package:budget_app/shared/models/section.dart';
import 'package:budget_app/home/view/widgets/categories_summary.dart';
import 'package:budget_app/home/cubit/home_cubit.dart';
import 'package:budget_app/shared/repositories/shared_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/bloc/app_bloc.dart';
import '../../shared/widgets/paginator/month_paginator.dart';
import '../../transactions/transaction/view/transaction_page.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeCubit(context.read<SharedRepositoryImpl>())..init(),
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*final selectedTab = context.select((HomeCubit cubit) => cubit.state.tab);*/
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final homeCubit = BlocProvider.of<HomeCubit>(context);
        return Container(
          color: scheme.background,
          child: SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  title: MonthPaginator(
                    onLeft: (date) =>
                        context.read<HomeCubit>().dateChanged(date),
                    onRight: (date) =>
                        context.read<HomeCubit>().dateChanged(date),
                  ),
                  centerTitle: true,
                  actions: <Widget>[
                    IconButton(
                      key: const Key('homePage_logout_iconButton'),
                      icon: const Icon(Icons.exit_to_app),
                      onPressed: () {
                        context.read<AppBloc>().add(const AppLogoutRequested());
                      },
                    )
                  ],
                ),
                drawer: Drawer(),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<TransactionPage>(
                        builder: (context) {
                          return BlocProvider.value(
                            value: homeCubit,
                            child: TransactionPage(),
                          );
                        },
                      ),
                    ).then((_) => context
                        .read<HomeCubit>()
                        .fetchSectionCategorySummary(
                            budgetId: state.budget!.id,
                            section: state.tab.name,
                            dateTime: state.selectedDate ?? DateTime.now()));
                  },
                  child: const Icon(Icons.add),
                ),
                body: state.budget == null
                    ? Center(child: CircularProgressIndicator())
                    : CategoriesSummary(
                        categorySummaryList:
                            state.sectionCategorySummary!.categorySummaryList,
                        dateTime: state.selectedDate),
                bottomNavigationBar: Container(
                  height: 230.h,
                  decoration: BoxDecoration(
                      color: scheme.primary,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.h),
                          topRight: Radius.circular(40.h)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 1,
                        )
                      ]),
                  child: BottomNavigationBar(
                    currentIndex: state.tab.index,
                    onTap: (value) {
                      context.read<HomeCubit>()..setTab(value);
                    },
                    elevation: 0,
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    selectedItemColor: scheme.primary,
                    unselectedItemColor: scheme.tertiary,
                    items: [
                      BottomNavigationBarItem(
                        label: 'expenses',
                        icon: Column(
                          children: [
                            Icon(Icons.account_balance_wallet),
                            Text(
                              '\$ ${state.sectionCategorySummary?.sectionMap[Section.EXPENSES] ?? '0.0'}',
                              style: TextStyle(
                                  fontWeight: state.tab == HomeTab.expenses
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            )
                          ],
                        ),
                      ),
                      BottomNavigationBarItem(
                        label: 'income',
                        icon: Column(
                          children: [
                            Icon(Icons.monetization_on_outlined),
                            Text(
                              '\$ ${state.sectionCategorySummary?.sectionMap[Section.INCOME] ?? '0.0'}',
                              style: TextStyle(
                                  fontWeight: state.tab == HomeTab.income
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      BottomNavigationBarItem(
                        label: 'accounts',
                        icon: Column(
                          children: [
                            Icon(Icons.account_balance_outlined),
                            Text(
                              '\$ ${state.sectionCategorySummary?.sectionMap[Section.ACCOUNTS] ?? '0.0'}',
                              style: TextStyle(
                                  fontWeight: state.tab == HomeTab.accounts
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ),
        );
      },
    );
  }
}
