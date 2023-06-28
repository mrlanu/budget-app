import 'package:budget_app/accounts/repository/accounts_repository.dart';
import 'package:budget_app/categories/repository/categories_repository.dart';
import 'package:budget_app/drawer/main_drawer.dart';
import 'package:budget_app/home/cubit/home_cubit.dart';
import 'package:budget_app/home/view/widgets/categories_summary.dart';
import 'package:budget_app/shared/models/section.dart';
import 'package:budget_app/subcategories/repository/subcategories_repository.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:budget_app/transactions/repository/transactions_repository.dart';
import 'package:budget_app/transfer/transfer.dart';
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
    final appBloc = BlocProvider.of<AppBloc>(context);
    return BlocProvider(
      create: (context) => HomeCubit(
        accountsRepository: context.read<AccountsRepositoryImpl>(),
          categoriesRepository: context.read<CategoriesRepositoryImpl>(),
          transactionsRepository: context.read<TransactionsRepositoryImpl>(),
          subcategoriesRepository: context.read<SubcategoriesRepositoryImpl>(),),
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    print('ICON: ${Icons.account_balance_outlined.codePoint}');
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          appBar: AppBar(
            backgroundColor: scheme.primaryContainer,
            title: state.tab != HomeTab.accounts
                ? MonthPaginator(
                    onLeft: (date) =>
                        context.read<HomeCubit>().changeDate(date),
                    onRight: (date) =>
                        context.read<HomeCubit>().changeDate(date),
                  )
                : Text('Accounts'),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                key: const Key('homePage_logout_iconButton'),
                icon: const Icon(Icons.exit_to_app),
                onPressed: () {
                  context.read<AppBloc>().add(const AppLogoutRequested());
                },
              ),
            ],
          ),
          drawer: MainDrawer(),
          floatingActionButton: _buildFAB(context, state),
          body: state.status == HomeStatus.loading
              ? Center(child: CircularProgressIndicator())
              : CategoriesSummary(
                  summaryList: state.summaryList,
                  dateTime: state.selectedDate),
          bottomNavigationBar: _buildBottomNavigationBar(context, state));
    });
  }
}

FloatingActionButton _buildFAB(BuildContext context, HomeState state) {
  return FloatingActionButton(
    onPressed: () {
      switch (state.tab) {
        case HomeTab.expenses:
          Navigator.of(context).push(
            TransactionPage.route(
                homeCubit: context.read<HomeCubit>(),
                transactionType: TransactionType.EXPENSE),
          );
        case HomeTab.income:
          Navigator.of(context).push(
            TransactionPage.route(
                homeCubit: context.read<HomeCubit>(),
                transactionType: TransactionType.INCOME),
          );
        case HomeTab.accounts:
          Navigator.of(context).push(
            TransferPage.route(homeCubit: context.read<HomeCubit>()),
          );
      }
      ;
    },
    child: const Icon(Icons.add),
  );
}

Widget _buildBottomNavigationBar(BuildContext context, HomeState state) {
  final scheme = Theme.of(context).colorScheme;
  return Container(
    height: 230.h,
    decoration: BoxDecoration(
        color: scheme.primary,
        /*borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.h), topRight: Radius.circular(40.h)),*/
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
          )
        ]),
    child: BottomNavigationBar(
      backgroundColor: scheme.primaryContainer,
      currentIndex: state.tab.index,
      onTap: (value) {
        context.read<HomeCubit>().setTab(value);
      },
      elevation: 0,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      selectedItemColor: scheme.primary,
      unselectedItemColor: scheme.tertiary,
      items: [
        _buildBottomNavigationBarItem(
            label: 'expenses',
            icon: Icons.account_balance_wallet,
            section: Section.EXPENSES,
            state: state,
            amount: state.sectionsSum['expenses']!,
            tab: HomeTab.expenses),
        _buildBottomNavigationBarItem(
            label: 'income',
            icon: Icons.monetization_on_outlined,
            section: Section.INCOME,
            state: state,
            amount: state.sectionsSum['incomes']!,
            tab: HomeTab.income),
        _buildBottomNavigationBarItem(
            label: 'accounts',
            icon: Icons.account_balance_outlined,
            section: Section.ACCOUNTS,
            amount: state.sectionsSum['accounts']!,
            state: state,
            tab: HomeTab.accounts),
      ],
    ),
  );
}

BottomNavigationBarItem _buildBottomNavigationBarItem(
    {required String label,
    required IconData icon,
    required Section section,
    required HomeState state,
    required double amount,
    required HomeTab tab}) {
  return BottomNavigationBarItem(
    label: label,
    icon: Column(
      children: [
        Icon(icon),
        Text(
          '\$ $amount',
          style: TextStyle(
              fontWeight:
                  state.tab == tab ? FontWeight.bold : FontWeight.normal),
        )
      ],
    ),
  );
}
