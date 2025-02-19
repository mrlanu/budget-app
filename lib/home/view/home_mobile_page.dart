import 'package:animations/animations.dart';
import 'package:budget_app/accounts_list/view/accounts_list_page.dart';
import 'package:budget_app/categories/view/categories_page.dart';
import 'package:budget_app/transfer/transfer.dart';
import 'package:budget_app/utils/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../navigation/main_drawer.dart';
import '../../shared/widgets/month_paginator.dart';
import '../../transaction/models/transaction_type.dart';
import '../../transaction/view/transaction_page.dart';
import '../home.dart';

class HomeMobilePage extends StatelessWidget {
  HomeMobilePage({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;
  final ContainerTransitionType _transitionType =
      ContainerTransitionType.fadeThrough;
  final double _fabDimension = 56.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return SafeArea(
            child: Scaffold(
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
                    /*IconButton(
                      key: const Key('homePage_logout_iconButton'),
                      icon: const Icon(Icons.create_new_folder_outlined),
                      onPressed: () {
                        switch (navigationShell.currentIndex) {
                          case 0:
                            context.push('/categories?typeIndex=0');
                            break;
                          case 1:
                            context.push('/categories?typeIndex=1');
                            break;
                          case 2:
                            context.push('/accounts-list');
                            break;
                        }
                      },
                    ),*/
                    _buildActionButton(),
                  ],
                ),
                drawer: MainDrawer(),
                body: navigationShell,
                floatingActionButton: _buildFab(
                    context,
                    state.tab.index == 0
                        ? TransactionType.EXPENSE
                        : TransactionType.INCOME),
                bottomNavigationBar:
                    HomeBottomNavBar(navigationShell: navigationShell)));
      },
    );
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
            color: Theme.of(context).colorScheme.onSecondary,
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
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        );
      },
    );
  }
}
