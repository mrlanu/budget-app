import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../transaction/transaction.dart';
import '../../../transfer/view/transfer_page.dart';
import '../../home.dart';

class HomeFloatingActionButton extends StatelessWidget {
  const HomeFloatingActionButton({super.key, required this.selectedTab});

  final HomeTab selectedTab;

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      onPressed: () {
        switch (selectedTab) {
          case HomeTab.expenses:
            Navigator.of(context).push(
              TransactionPage.route(
                  transactionType: TransactionType.EXPENSE,
                  date: homeCubit.state.selectedDate!),
            );
          case HomeTab.income:
            Navigator.of(context).push(
              TransactionPage.route(
                  transactionType: TransactionType.INCOME,
                  date: homeCubit.state.selectedDate!),
            );
          case HomeTab.accounts:
            Navigator.of(context).push(
              TransferPage.route(),
            );
        }
        ;
      },
      child: const Icon(
        Icons.add,
        color: Colors.black,
      ),
    );
  }
}
