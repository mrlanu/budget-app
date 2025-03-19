import 'package:qruto_budget/utils/theme/budget_theme.dart';
import 'package:qruto_budget/utils/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/colors.dart';
import '../../home.dart';

class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeCubit>().state;
    return Container(
      height: 82,
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: navigationShell.currentIndex,
            onTap: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
              context.read<HomeCubit>().setTab(index);
            },
            elevation: 0,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            selectedItemColor: BudgetTheme.isDarkMode(context)
                ? Colors.white
                : context.read<ThemeCubit>().state.secondaryColor,
            unselectedItemColor: BudgetColors.light,
            items: [
              _buildBottomNavigationBarItem(
                  label: 'expenses',
                  icon: Icons.account_balance_wallet,
                  color: BudgetColors.light,
                  selectedTab: state.tab,
                  amount: state.expenses,
                  tab: HomeTab.expenses,
                  context: context),
              _buildBottomNavigationBarItem(
                  label: 'income',
                  icon: Icons.monetization_on_outlined,
                  color: BudgetColors.light,
                  selectedTab: state.tab,
                  amount: state.incomes,
                  tab: HomeTab.income,
                  context: context),
              _buildBottomNavigationBarItem(
                  label: 'accounts',
                  icon: Icons.account_balance_outlined,
                  color: BudgetColors.light,
                  amount: state.accountsTotal,
                  selectedTab: state.tab,
                  tab: HomeTab.accounts,
                  context: context),
            ],
          );
        },
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      {required String label,
      required IconData icon,
      required Color color,
      required HomeTab selectedTab,
      required double amount,
      required HomeTab tab,
      required BuildContext context}) {
    return BottomNavigationBarItem(
      label: label,
      icon: Column(
        children: [
          Icon(icon),
          Text(
            '\$ ${amount.toStringAsFixed(2)}',
            style: TextStyle(
                color: Colors.white,
                fontWeight:
                    selectedTab == tab ? FontWeight.bold : FontWeight.normal),
          )
        ],
      ),
    );
  }
}
