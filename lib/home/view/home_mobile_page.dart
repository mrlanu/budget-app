import 'package:animations/animations.dart';
import 'package:qruto_budget/accounts_list/view/accounts_list_page.dart';
import 'package:qruto_budget/categories/view/categories_page.dart';
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
        ),
        body: navigationShell,
        floatingActionButton: Builder(
          builder: (context) {
            final tab = context.select((HomeCubit cubit) => cubit.state.tab);
            return _buildFab(
                context,
                tab.index == 0
                    ? TransactionType.EXPENSE
                    : TransactionType.INCOME);
          },
        ),
        bottomNavigationBar:
            HomeBottomNavBar(navigationShell: navigationShell));
  }

  Widget _buildActionButton() {
    return OpenContainer(
      transitionType: _transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return navigationShell.currentIndex == 2
            ? AccountsListPage()
            : CategoriesPage(
                transactionType: navigationShell.currentIndex == 0
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
}
