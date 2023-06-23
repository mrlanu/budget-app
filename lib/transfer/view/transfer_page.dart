import 'package:budget_app/home/cubit/home_cubit.dart';
import 'package:budget_app/transactions/models/transaction_tile.dart';
import 'package:budget_app/transactions/repository/transactions_repository.dart';
import 'package:budget_app/transfer/transfer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../accounts/repository/accounts_repository.dart';
import '../../app/bloc/app_bloc.dart';
import '../../categories/repository/categories_repository.dart';

class TransferPage extends StatelessWidget {
  const TransferPage({Key? key}) : super(key: key);

  static Route<void> route({required HomeCubit homeCubit, TransactionTile? transactionTile}) {
    return MaterialPageRoute(builder: (context) {
      final appBloc = BlocProvider.of<AppBloc>(context);
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
            TransferBloc(
              budgetId: appBloc.state.budget!.id,
              transactionsRepository: context.read<TransactionsRepositoryImpl>(),
              categoriesRepository: context.read<CategoriesRepositoryImpl>(),
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
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<TransferBloc, TransferState>(
      builder: (context, state) {
        return Scaffold(
            backgroundColor: scheme.secondaryContainer,
            appBar: AppBar(
              backgroundColor: scheme.primaryContainer,
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
