import 'package:animations/animations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qruto_budget/accounts_list/view/accounts_list_page.dart';
import 'package:qruto_budget/categories/view/categories_page.dart';
import 'package:qruto_budget/home/view/widgets/home_navbar.dart';
import 'package:qruto_budget/transfer/transfer.dart';
import 'package:qruto_budget/utils/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../shared/widgets/month_paginator.dart';
import '../../transaction/models/transaction_type.dart';
import '../../transaction/view/transaction_page.dart';
import '../home.dart';

class HomeMobilePage extends StatelessWidget {
  HomeMobilePage(
      {required this.navigationShell, Key? key, required this.onDrawer})
      : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final Function() onDrawer;
  final StatefulNavigationShell navigationShell;
  final ContainerTransitionType _transitionType =
      ContainerTransitionType.fadeThrough;
  final double _fabDimension = 56.0;

  @override
  Widget build(BuildContext context) {
    const bottomH = 48.0;
    final colorState = context.read<ThemeCubit>().state;

    return Scaffold(
        appBar: AppBar(
          title: MonthPaginator(
              onLeft: (date) => context.read<HomeCubit>().changeDate(date),
              onRight: (date) => context.read<HomeCubit>().changeDate(date)),
          centerTitle: true,
          leading: _buildActionButton(),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                onDrawer();
              },
            ),
          ],
          bottom: _buildSummaryBar(
              size: bottomH, color: colorState.primaryColor),
        ),
        body: navigationShell,
        floatingActionButton: Builder(
          builder: (context) {
            final tab = context.select((HomeCubit cubit) => cubit.state.tab);
            return _buildFab(
                context,
                tab.index == HomeTab.expenses.index
                    ? TransactionType.EXPENSE
                    : TransactionType.INCOME);
          },
        ),
        bottomNavigationBar: HomeNavBar(navigationShell: navigationShell));
  }

  PreferredSizeWidget _buildSummaryBar(
      {required double size, required MaterialColor color}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(size),
      child: Container(
        decoration: BoxDecoration(color: color[300],
          border: Border(
            bottom: BorderSide(
              color: color[50]!,
              width: 2,
            ),
          ),
        ),
        height: size,
        child: SizedBox.expand(
          child: Builder(builder: (context) {
            final state = context.watch<HomeCubit>().state;
            final balance = state.incomes - state.expenses;
            return state.tab.index == HomeTab.accounts.index
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: '\$ ',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(
                                  text: state.accountsTotal.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          /*Text(
                            'total balance',
                            style: TextStyle(color: Colors.white),
                          )*/
                        ],
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _getBalanceItem(
                        amount: state.incomes,
                        selectedTab: HomeTab.income == state.tab,
                        label: 'income',
                      ),
                      Text(
                        '-',
                        style: TextStyle(
                          fontSize: 25.sp,
                          color: Colors.white,
                        ),
                      ),
                      _getBalanceItem(
                        amount: state.expenses,
                        selectedTab: HomeTab.expenses == state.tab,
                        label: 'expenses',
                      ),
                      Text(
                        '=',
                        style: TextStyle(
                          fontSize: 25.sp,
                          color: Colors.white,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: '\$ ',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(
                              text: balance.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 25.sp,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
          }),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return OpenContainer(
      transitionType: _transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return navigationShell.currentIndex == 2
            ? AccountsListPage()
            : CategoriesPage(
                transactionType: navigationShell.currentIndex == 1
                    ? TransactionType.EXPENSE
                    : TransactionType.INCOME);
      },
      closedElevation: 0,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(56.0 / 2),
        ),
      ),
      closedColor: Colors.transparent,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Icon(
            Icons.create_new_folder_outlined,
            color: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildFab(BuildContext context, TransactionType transactionType) {
    return OpenContainer(
      transitionType: _transitionType,
      openBuilder: (BuildContext _, VoidCallback openContainer) {
        return navigationShell.currentIndex == 2
            ? TransferPage()
            : TransactionPage(
                transactionType: transactionType,
              );
      },
      closedElevation: 6.0,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(_fabDimension / 4),
        ),
      ),
      closedColor: context.read<ThemeCubit>().state.secondaryColor,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return SizedBox(
          height: _fabDimension,
          width: _fabDimension,
          child: Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _getBalanceItem({
    required double amount,
    required bool selectedTab,
    required String label,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            text: '\$ ',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: selectedTab ? Colors.white : Colors.white60),
            children: <TextSpan>[
              TextSpan(
                  text: '${amount.toStringAsFixed(2)}',
                  style: selectedTab
                      ? TextStyle(
                          color: Colors.white,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold)
                      : TextStyle(
                          color: Colors.white60,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.normal)),
            ],
          ),
        ),
        /*Text(
          label,
          style: TextStyle(color: selectedTab ? Colors.white : Colors.white60),
        )*/
      ],
    );
  }
}
