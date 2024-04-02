import 'package:budget_app/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../budgets/repository/budget_repository.dart';
import '../transaction.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage(
      {super.key, this.transaction, required this.transactionType});

  final ComprehensiveTransaction? transaction;
  final TransactionType transactionType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionBloc(
          transactionsRepository: context.read<TransactionsRepository>(),
          budgetRepository: context.read<BudgetRepository>())
        ..add(TransactionBudgetChanged(
            budget: context.read<HomeCubit>().state.budget))
        ..add(TransactionFormLoaded(
          transaction: transaction,
          transactionType: transactionType,
        )),
      child: TransactionView(),
    );
  }
}

class TransactionView extends StatelessWidget {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionType =
        context.select((TransactionBloc bloc) => bloc.state.transactionType);
    final status =
        context.select((TransactionBloc bloc) => bloc.state.trStatus);
    return Scaffold(
        appBar: AppBar(
          title: Text(_buildTitle(transactionType)),
        ),
        body: status == TransactionStatus.success
            ? TransactionForm()
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  String _buildTitle(TransactionType type) {
    //final prefix = state.isEdit ? 'Edit' : 'New';
    final prefix = 'New';
    final body = switch (type) {
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
      ComprehensiveTransaction? transaction,
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
