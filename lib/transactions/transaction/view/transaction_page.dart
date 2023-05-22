import 'package:budget_app/app/app.dart';
import 'package:budget_app/transactions/repository/transactions_repository.dart';
import 'package:budget_app/transactions/transaction/bloc/transaction_bloc.dart';
import 'package:budget_app/transactions/transaction/view/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/transaction.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({Key? key}) : super(key: key);

  static const routeName = '/transaction';

  static Route<void> route({Transaction? transaction}) {
    return MaterialPageRoute(builder: (context) {
      final appBloc = BlocProvider.of<AppBloc>(context);
      return BlocProvider(
        create: (context) => TransactionBloc(
          budget: appBloc.state.budget!,
          transactionsRepository: context.read<TransactionsRepositoryImpl>(),
        )..add(TransactionFormLoaded(transaction: transaction)),
        child: TransactionPage(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title:
                  Text(state.isEdit ? 'Edit Transaction' : 'New Transaction'),
            ),
            body: state.trStatus == TransactionStatus.success
                ? TransactionForm()
                : Center(
                    child: CircularProgressIndicator(),
                  ));
      },
    );
  }
}
