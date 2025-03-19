import 'package:budget_app/accounts_list/repository/account_repository.dart';
import 'package:budget_app/categories/repository/category_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../transaction.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({
    super.key,
    this.transactionId,
    required this.transactionType,
  });

  final int? transactionId;
  final TransactionType transactionType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionBloc(
          transactionsRepository: context.read<TransactionRepository>(),
          categoryRepository: context.read<CategoryRepository>(),
          accountRepository: context.read<AccountRepository>())
        ..add(TransactionFormLoaded(
            transactionId: transactionId, transactionType: transactionType)),
      child: TransactionView(),
    );
  }
}

class TransactionView extends StatelessWidget {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    context.select((TransactionBloc bloc) => bloc.state.transactionType);
    final status =
        context.select((TransactionBloc bloc) => bloc.state.trStatus);
    return Scaffold(
        appBar: AppBar(
          title: Builder(builder: (context) {
            final isIdExist =
                context.select((TransactionBloc bloc) => bloc.state.id) != null;
            return Text(isIdExist ? 'Edit Transaction' : 'New Transaction',
                style: TextStyle(fontSize: 36.sp));
          }),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              context.pop();
            },
          ),
        ),
        body: status == TransactionStatus.success
            ? TransactionForm()
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}

class TransactionWindow extends StatelessWidget {
  const TransactionWindow({Key? key}) : super(key: key);

  static Widget window(
      {Key? key,
      TransactionTile? transaction,
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
