import 'package:budget_app/accounts/repository/accounts_repository.dart';
import 'package:budget_app/app/app.dart';
import 'package:budget_app/categories/repository/categories_repository.dart';
import 'package:budget_app/subcategories/repository/subcategories_repository.dart';
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

  static Route<void> route(
      {required HomeCubit homeCubit, TransactionTile? transaction,
        required TransactionType transactionType}) {
    return MaterialPageRoute(builder: (context) {
      final appBloc = BlocProvider.of<AppBloc>(context);
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
            TransactionBloc(
              transactionsRepository: context.read<
                  TransactionsRepositoryImpl>(),
              categoriesRepository: context.read<CategoriesRepositoryImpl>(),
              subcategoriesRepository: context.read<
                  SubcategoriesRepositoryImpl>(),
              accountsRepository: context.read<AccountsRepositoryImpl>(),
            )
              ..add(TransactionFormLoaded(
                  transaction: transaction, transactionType: transactionType)),
          ),
          BlocProvider.value(value: homeCubit),
        ],
        child: TransactionPage(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return Scaffold(
            backgroundColor: scheme.secondaryContainer,
            appBar: AppBar(
              backgroundColor: scheme.primaryContainer,
              title: Text(_buildTitle(state)),
            ),
            body: state.trStatus == TransactionStatus.success
                ? TransactionForm()
                : Center(child: CircularProgressIndicator(),
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
