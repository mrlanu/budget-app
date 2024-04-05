import 'package:budget_app/budgets/budgets.dart';
import 'package:budget_app/transfer/transfer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../budgets/repository/budget_repository.dart';
import '../../transaction/transaction.dart';

class TransferPage extends StatelessWidget {
  const TransferPage({super.key, this.transaction, required this.budget});

  final ComprehensiveTransaction? transaction;
  final Budget budget;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransferBloc(
          transactionsRepository: context.read<TransactionsRepository>(),
          budgetRepository: context.read<BudgetRepository>())
          ..add(TransferBudgetChanged(
          budget: budget!))
        ..add(TransferFormLoaded(transaction: transaction)),
      child: TransferView(),
    );
  }
}

class TransferView extends StatelessWidget {
  const TransferView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransferBloc, TransferState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Transfer'),
            ),
            body: state.trStatus == TransferStatus.success
                ? TransferForm()
                : Center(
                    child: CircularProgressIndicator(),
                  ));
      },
    );
  }
}

class TransferWindow extends StatelessWidget {
  const TransferWindow({Key? key}) : super(key: key);

  static Widget window(
      {Key? key,
      ComprehensiveTransaction? transaction,
      required TransactionType transactionType}) {
    return TransferWindow(
      key: key,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransferBloc, TransferState>(
      builder: (context, state) {
        return state.trStatus == TransferStatus.success
            ? TransferForm()
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
