import 'package:budget_app/accounts_list/repository/account_repository.dart';
import 'package:budget_app/transfer/transfer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../transaction/transaction.dart';

class TransferPage extends StatelessWidget {
  const TransferPage({super.key, this.transactionId});

  final int? transactionId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransferBloc(
          transactionsRepository: context.read<TransactionRepository>(),
          accountRepository: context.read<AccountRepository>())
        ..add(TransferFormLoaded(transactionId: transactionId)),
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
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  context.pop();
                },
              ),
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
      TransactionTile? transaction,
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
