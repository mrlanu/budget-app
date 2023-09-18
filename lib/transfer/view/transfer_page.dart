import 'package:budget_app/home/cubit/home_cubit.dart';
import 'package:budget_app/transactions/models/transaction_tile.dart';
import 'package:budget_app/transactions/repository/transactions_repository.dart';
import 'package:budget_app/transfer/transfer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../accounts/repository/accounts_repository.dart';
import '../../transactions/models/transaction_type.dart';

class TransferPage extends StatelessWidget {
  const TransferPage({Key? key}) : super(key: key);

  static Route<void> route({required HomeCubit homeCubit, TransactionTile? transactionTile}) {
    return MaterialPageRoute(builder: (context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
            TransferBloc(
              transactionsRepository: context.read<TransactionsRepositoryImpl>(),
              accountsRepository: context.read<AccountsRepositoryImpl>(),
            )
              ..add(TransferFormLoaded(transactionTile: transactionTile)),
          ),
          BlocProvider.value(value: homeCubit),
        ],
        child: TransferPage(),
      );
    });
  }

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
      {Key? key, TransactionTile? transaction,
        required TransactionType transactionType}) {
    return  TransferWindow(key: key,);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransferBloc, TransferState>(
      builder: (context, state) {
        return state.trStatus == TransferStatus.success
            ? TransferForm()
            : Center(child: CircularProgressIndicator(),
        );
      },
    );
  }
}
