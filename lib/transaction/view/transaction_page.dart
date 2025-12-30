import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qruto_budget/accounts_list/repository/account_repository.dart';
import 'package:qruto_budget/categories/repository/category_repository.dart';

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
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
                  state.id != null
                      ? 'Edit Transaction'
                      : state.transactionType == TransactionType.EXPENSE
                          ? 'Add Expense'
                          : 'Add Income',
                  style: TextStyle(fontSize: 30.sp)),
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                context.pop();
              },
            ),
          ),
          body: state.trStatus == TransactionStatus.success
              ? TransactionForm()
              : Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
