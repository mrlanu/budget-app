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
    final appBloc = BlocProvider.of<AppBloc>(context);
    return BlocProvider(
      create: (context) => HomeCubit(
          sharedRepository: context.read<SharedRepositoryImpl>(),
          budgetId: appBloc.state.budget!.id)
        ..init(),
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Container(
          color: scheme.background,
          child: SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  title: state.tab != HomeTab.accounts
                      ? MonthPaginator(
                          onLeft: (date) =>
                              context.read<HomeCubit>().dateChanged(date),
                          onRight: (date) =>
                              context.read<HomeCubit>().dateChanged(date),
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
                    )
                  ],
                ),
                drawer: Drawer(),
                floatingActionButton: _buildFAB(context, state),
                body: CategoriesSummary(
                        summaryList: state.summaryList,
                        dateTime: state.selectedDate),
                bottomNavigationBar: _buildBottomNavigationBar(context, state)),
          ),
        );
      },
    );
  }
}

FloatingActionButton _buildFAB(BuildContext context, HomeState state) {
  final homeCubit = BlocProvider.of<HomeCubit>(context);
  return FloatingActionButton(
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
      ); /*.then((_) => context
          .read<HomeCubit>()
          .fetchSectionCategorySummary(
          budgetId: state.budget!.id,
          section: state.tab.name,
          dateTime: state.selectedDate ?? DateTime.now()));*/
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
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.h), topRight: Radius.circular(40.h)),
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
        context.read<HomeCubit>().setTab(value);
      },
      elevation: 0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: scheme.primary,
      unselectedItemColor: scheme.tertiary,
      items: [
        _buildBottomNavigationBarItem(
            label: 'expenses',
            icon: Icons.account_balance_wallet,
            section: Section.EXPENSES,
            state: state,
            tab: HomeTab.expenses),
        _buildBottomNavigationBarItem(
            label: 'income',
            icon: Icons.monetization_on_outlined,
            section: Section.INCOME,
            state: state,
            tab: HomeTab.income),
        _buildBottomNavigationBarItem(
            label: 'accounts',
            icon: Icons.account_balance_outlined,
            section: Section.ACCOUNTS,
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
    required HomeTab tab}) {
  return BottomNavigationBarItem(
    label: label,
    icon: Column(
      children: [
        Icon(icon),
        Text(
          '\$ ${state.sectionSummary[section.name] ?? '0.0'}',
          style: TextStyle(
              fontWeight:
                  state.tab == tab ? FontWeight.bold : FontWeight.normal),
        )
      ],
    ),
  );
}
