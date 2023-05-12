import 'package:budget_app/categories/view/categories_page.dart';
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
      create: (context) => HomeCubit(context.read<SharedRepositoryImpl>())
        ..fetchAllSections()
        ..fetchAllCategories(HomeTab.expenses.name),
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
        return Container(
          color: scheme.background,
          child: SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  title: MonthPaginator(onLeft: (){}, onRight: (){}),
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
                    Navigator.of(context)
                        .pushNamed(TransactionPage.routeName);
                        /*.then((_) {
                      context.read<HomeCubit>().fetchAllSections();
                    });*/
                  },
                  child: const Icon(Icons.add),
                ),
                body: CategoriesPage(),
                bottomNavigationBar: Container(
                  height: 230.h,
                  width: 500.w,
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
                      context.read<HomeCubit>()
                        ..fetchAllCategories(HomeTab.values[value].name)
                        ..setTab(value);
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
                              '\$ ${state.sectionSummary['EXPENSES']}',
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
                              '\$ ${state.sectionSummary['INCOME']}',
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
                              '\$ ${state.sectionSummary['ACCOUNTS']}',
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
