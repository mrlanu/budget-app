import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:budget_app/transactions/transaction/bloc/transaction_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../colors.dart';
import '../../../constants/constants.dart';
import '../../../shared/models/section.dart';
import '../../cubit/home_cubit.dart';

class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar(
      {super.key,
      this.selectedTab = HomeTab.expenses,
      required this.sectionsSum});

  final HomeTab selectedTab;
  final Map<String, double> sectionsSum;

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
        child: BottomNavigationBar(
          backgroundColor: scheme.primary,
          currentIndex: selectedTab.index,
          onTap: (value) {
            context.read<HomeCubit>().setTab(value);
            if (isDisplayDesktop(context)) {
              final tab = HomeTab.values[value];
              var tType = switch (tab) {
                HomeTab.expenses => TransactionType.EXPENSE,
                HomeTab.income => TransactionType.INCOME,
                HomeTab.accounts => TransactionType.TRANSFER,
              };
              context.read<TransactionBloc>().add(TransactionFormLoaded(
                  transactionType: tType,
                  date: context.read<HomeCubit>().state.selectedDate!));
            }
          },
          elevation: 0,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedItemColor: BudgetColors.amber800,
          unselectedItemColor: scheme.surfaceVariant,
          items: [
            _buildBottomNavigationBarItem(
                label: 'expenses',
                icon: Icons.account_balance_wallet,
                color: scheme.onPrimary,
                section: Section.EXPENSES,
                selectedTab: selectedTab,
                amount: sectionsSum['expenses']!,
                tab: HomeTab.expenses),
            _buildBottomNavigationBarItem(
                label: 'income',
                icon: Icons.monetization_on_outlined,
                color: scheme.onPrimary,
                section: Section.INCOME,
                selectedTab: selectedTab,
                amount: sectionsSum['incomes']!,
                tab: HomeTab.income),
            _buildBottomNavigationBarItem(
                label: 'accounts',
                icon: Icons.account_balance_outlined,
                color: scheme.onPrimary,
                section: Section.ACCOUNTS,
                amount: sectionsSum['accounts']!,
                selectedTab: selectedTab,
                tab: HomeTab.accounts),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      {required String label,
      required IconData icon,
      required Color color,
      required Section section,
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
