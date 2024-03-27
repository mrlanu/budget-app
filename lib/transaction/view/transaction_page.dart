import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../transaction.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage(
      {super.key, this.transaction, required this.transactionType});

  final Transaction? transaction;
  final TransactionType transactionType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionBloc(
          transactionsRepository: context.read<TransactionsRepository>(),
          budgetRepository: context.read<BudgetRepository>()),
      child: TransactionView(
        transaction: transaction,
        transactionType: transactionType,
      ),
    );
  }
}

class TransactionView extends StatelessWidget {
  const TransactionView(
      {super.key, this.transaction, required this.transactionType});

  final Transaction? transaction;
  final TransactionType transactionType;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionBloc, TransactionState>(
      listenWhen: (previous, current) {
        return previous.budget != current.budget;},
      listener: (context, state) {
        context.read<TransactionBloc>().add(TransactionFormLoaded(
          transaction: transaction,
          transactionType: transactionType,
        ));
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text(_buildTitle(state)),
            ),
            body: state.trStatus == TransactionStatus.success
                ? TransactionForm()
                : Center(
              child: CircularProgressIndicator(),
            ));
      },
    );
  }

  String _buildTitle(TransactionState state) {
    //final prefix = state.isEdit ? 'Edit' : 'New';
    final prefix = 'New';
    final body = switch (state.transactionType) {
      TransactionType.EXPENSE => 'Expense',
      TransactionType.INCOME => 'Income',
      TransactionType.TRANSFER => 'Transfer',
      TransactionType.ACCOUNT => 'Account',
    };
    return '$prefix $body';
  }
}

class TransactionWindow extends StatelessWidget {
  const TransactionWindow({Key? key}) : super(key: key);

  static Widget window(
      {Key? key,
        TransactionTile? transaction,
        required TransactionType transactionType}) {
    return TransactionWindow(
      key: key,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return state.trStatus == TransactionStatus.success
            ? TransactionForm()
            : Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
