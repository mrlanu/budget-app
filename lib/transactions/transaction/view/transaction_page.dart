import 'package:budget_app/home/cubit/home_cubit.dart';
import 'package:budget_app/transactions/transaction/cubit/transaction_cubit.dart';
import 'package:budget_app/transactions/repository/transactions_repository.dart';
import 'package:budget_app/transactions/transaction/view/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/repositories/shared_repository.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({Key? key}) : super(key: key);

  static const routeName = '/transaction';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new transaction'),
      ),
      body: BlocProvider(
        create: (context) => TransactionCubit(
            context.select((HomeCubit cubit) => cubit.state.budget!),
            context.read<SharedRepositoryImpl>(),
            context.read<TransactionRepositoryImpl>()),
        child: TransactionForm(),
      ),
    );
  }
}
