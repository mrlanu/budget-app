import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/transactions/models/transaction_tile.dart';
import 'package:budget_app/transactions/repository/transactions_repository.dart';
import 'package:budget_app/transactions/transaction/bloc/transaction_bloc.dart';
import 'package:budget_app/transactions/transaction/view/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/cubit/home_cubit.dart';
import '../../models/transaction_type.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({Key? key}) : super(key: key);

  static const routeName = '/transaction';

  static Route<void> route({required HomeCubit homeCubit,
    TransactionTile? transaction,
    required TransactionType transactionType,
    required DateTime date}) {
    return MaterialPageRoute(
        builder: (ctx) {
          final ts = ctx.read<TransactionsRepositoryImpl>();
      return RepositoryProvider.value(
        value: ctx.read<TransactionsRepositoryImpl>(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
              TransactionBloc(
                  transactionsRepository:
                  ctx.read<TransactionsRepositoryImpl>(),
                  budgetRepository: context.read<BudgetRepository>())
                ..add(TransactionFormLoaded(
                    transaction: transaction,
                    transactionType: transactionType,
                    date: date)),
            ),
            BlocProvider.value(value: homeCubit),
          ],
          child: TransactionPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
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

  static Widget window({Key? key,
    TransactionTile? transaction,
    required TransactionType transactionType}) {
    return TransactionWindow(
      key: key,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) =>
      previous.selectedDate != current.selectedDate,
      listener: (context, state) {
        final transactionType = switch (state.tab) {
          HomeTab.expenses => TransactionType.EXPENSE,
          HomeTab.income => TransactionType.INCOME,
          HomeTab.accounts => TransactionType.ACCOUNT
        };
        context.read<TransactionBloc>().add(TransactionFormLoaded(
            transactionType: transactionType, date: state.selectedDate!));
      },
      child: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          return state.trStatus == TransactionStatus.success
              ? TransactionForm()
              : Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
