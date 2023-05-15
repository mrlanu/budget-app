import 'package:budget_app/transactions/repository/transactions_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../shared/models/category.dart';
import '../../shared/widgets/entity_view_widget.dart';
import '../cubit/transactions_cubit.dart';

class TransactionsPage extends StatelessWidget {
  static const routeName = '/transactions';

  const TransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    return BlocProvider(
      create: (context) =>
          TransactionsCubit(context.read<TransactionRepositoryImpl>())
            ..fetchTransactions(
                categoryId: args['category'].id,
                date: args['date'] as DateTime),
      child: TransactionsView(category: args['category'] as Category,),
    );
  }
}

class TransactionsView extends StatelessWidget {

  final Category category;

  const TransactionsView({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsCubit, TransactionsState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(category.name),
            ),
            body: state.status == TransactionsStatus.loading
                ? CircularProgressIndicator()
                : ListView.builder(
                    itemCount: state.transactionList.length,
                    itemBuilder: (context, index) {
                      final tr = state.transactionList[index];
                      return EntityView(
                        title: tr.subcategory,
                        subtitle: tr.account,
                        subtitlePrefix: DateFormat('MM-dd-yyyy').format(tr.date),
                        routeName: '',
                        amount: tr.amount.toString(),
                        suffix: Icon(Icons.chevron_right),
                        onTap: () => {});
                    }));
      },
    );
  }
}
