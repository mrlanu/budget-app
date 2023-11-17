import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../transactions/models/transaction_type.dart';
import '../../../transactions/transaction/view/transaction_page.dart';
import '../../../transfer/view/transfer_page.dart';
import '../../cubit/home_cubit.dart';

class HomeFloatingActionButton extends StatelessWidget {
  const HomeFloatingActionButton({super.key, required this.selectedTab});

  final HomeTab selectedTab;

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    return FloatingActionButton(
      onPressed: () {
        switch (selectedTab) {
          case HomeTab.expenses:
            Navigator.of(context).push(
              TransactionPage.route(
                  homeCubit: homeCubit,
                  transactionType: TransactionType.EXPENSE,
                  date: homeCubit.state.selectedDate!),
            );
          case HomeTab.income:
            Navigator.of(context).push(
              TransactionPage.route(
                  homeCubit: context.read<HomeCubit>(),
                  transactionType: TransactionType.INCOME,
                  date: homeCubit.state.selectedDate!),
            );
          case HomeTab.accounts:
            Navigator.of(context).push(
              TransferPage.route(homeCubit: context.read<HomeCubit>()),
            );
        }
        ;
      },
      child: const Icon(
        Icons.add,
      ),
    );
  }
}
