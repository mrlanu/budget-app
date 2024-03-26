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
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 80,
      child: Theme(
        data: Theme.of(context).copyWith(
          //splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
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
                /*if (isDisplayDesktop(context)) {
                  final tab = HomeTab.values[value];
                  var tType = switch (tab) {
                    HomeTab.expenses => TransactionType.EXPENSE,
                    HomeTab.income => TransactionType.INCOME,
                    HomeTab.accounts => TransactionType.TRANSFER,
                  };
                  context.read<TransactionBloc>().add(TransactionFormLoaded(
                      transactionType: tType,
                      date: context.read<HomeCubit>().state.selectedDate!));
                }*/
              },
              elevation: 0,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              selectedItemColor: BudgetColors.accent,
              unselectedItemColor: BudgetColors.light,
              items: [
                _buildBottomNavigationBarItem(
                    label: 'expenses',
                    icon: Icons.account_balance_wallet,
                    color: BudgetColors.light,
                    selectedTab: state.tab,
                    amount: state.expenses,
                    tab: HomeTab.expenses),
                _buildBottomNavigationBarItem(
                    label: 'income',
                    icon: Icons.monetization_on_outlined,
                    color: BudgetColors.light,
                    selectedTab: state.tab,
                    amount: state.incomes,
                    tab: HomeTab.income),
                _buildBottomNavigationBarItem(
                    label: 'accounts',
                    icon: Icons.account_balance_outlined,
                    color: BudgetColors.light,
                    amount: state.accountsTotal,
                    selectedTab: state.tab,
                    tab: HomeTab.accounts),
              ],
            );
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      {required String label,
      required IconData icon,
      required Color color,
      required HomeTab selectedTab,
      required double amount,
      required HomeTab tab}) {
    return BottomNavigationBarItem(
      label: label,
      icon: Column(
        children: [
          Icon(icon),
          Text(
            '\$ ${amount.toStringAsFixed(2)}',
            style: TextStyle(
                color: color,
                fontWeight:
                    selectedTab == tab ? FontWeight.bold : FontWeight.normal),
          )
        ],
      ),
    );
  }
}
