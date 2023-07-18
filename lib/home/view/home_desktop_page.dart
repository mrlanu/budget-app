import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/drawer/main_drawer.dart';
import 'package:budget_app/home/view/widgets/accounts_summaries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../accounts/cubit/accounts_cubit.dart';
import '../../colors.dart';
import '../../shared/widgets/paginator/month_paginator.dart';
import '../home.dart';

class HomeDesktopPage extends StatelessWidget {
  const HomeDesktopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BudgetColors.teal100,
        body: Row(
          children: [MainDrawer(), _Body()],
        ));
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.03),
        child: BlocListener<HomeCubit, HomeState>(
          listenWhen: (previous, current) => previous.tab != current.tab && current.tab == HomeTab.accounts,
          listener: (context, state) {
            // it has been added for update accounts during first tab open
            context.read<AccountsCubit>().fetchAllAccounts();
          },
          child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) =>
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(15),
                        width: w * 0.3,
                        height: 80,
                        decoration: BoxDecoration(
                            color: BudgetColors.teal900,
                            borderRadius: BorderRadius.circular(15)),
                        child: MonthPaginator(
                          fontSize: 20,
                          color: BudgetColors.teal50,
                          onLeft: (date) =>
                              context.read<HomeCubit>().changeDate(date),
                          onRight: (date) =>
                              context.read<HomeCubit>().changeDate(date),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Column(
                              children: [
                                Card(
                                  color: BudgetColors.teal50,
                                  elevation: 5,
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    width: w * 0.3,
                                    height: h * 0.7,
                                    child: state.status == HomeStatus.loading
                                        ? Center(
                                        child: CircularProgressIndicator())
                                        : state.tab == HomeTab.accounts
                                        ? AccountsSummaries()
                                        : CategorySummaries(),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              children: [
                                Card(
                                  color: BudgetColors.teal50,
                                  elevation: 5,
                                  child: Container(
                                      width: w * 0.3,
                                      height: h * 0.7,
                                      child: Container() /*TransactionsView()*/),
                                ) //TransactionsViewBody())
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: w * 0.3,
                        decoration: BoxDecoration(
                            color: BudgetColors.teal900,
                            borderRadius: BorderRadius.circular(15)),
                        child: ClipPath(
                          clipper: ShapeBorderClipper(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          child: HomeBottomNavBar(
                              selectedTab: state.tab,
                              sectionsSum: state.sectionsSum),
                        ),
                      )
                    ],
                  )),
        ),
      ),
    );
  }
}
