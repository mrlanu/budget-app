import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../drawer/main_drawer.dart';
import '../../shared/widgets/month_paginator.dart';
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
                            context.push('/categories?typeIndex=0');
                            break;
                          case 1:
                            context.push('/categories?typeIndex=0');
                            break;
                          case 2:
                            context.push('/accounts-list');
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
