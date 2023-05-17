import 'package:budget_app/app/app.dart';
import 'package:budget_app/shared/repositories/shared_repository.dart';
import 'package:budget_app/transactions/repository/transactions_repository.dart';
import 'package:budget_app/transactions/transaction/cubit/transaction_cubit.dart';
import 'package:budget_app/transactions/transaction/view/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({Key? key}) : super(key: key);

  static const routeName = '/transaction';

  @override
  Widget build(BuildContext context) {
    final appCubit = BlocProvider.of<AppBloc>(context);
    final sharedRepo = context.read<SharedRepositoryImpl>();
    final transRepo = context.read<TransactionsRepositoryImpl>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new transaction'),
      ),
      body: BlocProvider(
        create: (context) => TransactionCubit(
            budget: appCubit.state.budget!,
            sharedRepository: sharedRepo,
            transactionsRepository: transRepo),
        child: TransactionForm(),
      ),
    );
  }
}
