import 'package:budget_app/home/cubit/home_cubit.dart';
import 'package:budget_app/transactions/repository/transactions_repository.dart';
import 'package:budget_app/transactions/view/widgets/transaction_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/bloc/app_bloc.dart';
import '../cubit/transactions_cubit.dart';
import '../transaction/view/transaction_page.dart';

class TransactionsPage extends StatelessWidget {
  static const routeName = '/transactions';

  static Route<void> route(
      {required HomeCubit homeCubit,
      required TransactionsFilter filterBy,
      required String filterId,
      required DateTime dateTime}) {
    return MaterialPageRoute(builder: (context) {
      final appBloc = BlocProvider.of<AppBloc>(context);
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TransactionsCubit(
                budgetId: appBloc.state.budget!.id,
                transactionsRepository:
                    context.read<TransactionsRepositoryImpl>())
              ..fetchTransactions(
                  filterBy: filterBy, filterId: filterId, date: dateTime),
          ),
          BlocProvider.value(value: homeCubit),
        ],
        child: TransactionsPage(),
      );
    });
  }

  const TransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionsCubit, TransactionsState>(
        listenWhen: (previous, current) =>
            previous.lastDeletedTransaction != current.lastDeletedTransaction &&
            current.lastDeletedTransaction != null,
        listener: (context, state) {
          final messenger = ScaffoldMessenger.of(context);
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                duration: Duration(seconds: 5),
                content: Text(
                  'Transaction deleted',
                ),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    messenger.hideCurrentSnackBar();
                    context.read<TransactionsCubit>().undoDelete();
                  },
                ),
              ),
            );
        },
        child: BlocConsumer<TransactionsCubit, TransactionsState>(
          listenWhen: (previous, current) =>
              previous.transactionList != current.transactionList,
          listener: (context, state) {
            context.read<HomeCubit>().init();
          },
          builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text('Transactions'),
                ),
                body: state.status == TransactionsStatus.loading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: state.transactionList.length,
                        itemBuilder: (context, index) {
                          final tr = state.transactionList[index];
                          return TransactionListTile(
                            transaction: tr,
                            onDismissed: (_) {
                              context
                                  .read<TransactionsCubit>()
                                  .deleteTransaction(transaction: tr);
                            },
                            onTap: () => {
                              Navigator.of(context).push(
                                TransactionPage.route(
                                    homeCubit: context.read<HomeCubit>(),
                                    transaction: tr,
                                    transactionType: tr.type!),
                              )
                            },
                          );
                        }));
          },
        ));
  }
}
