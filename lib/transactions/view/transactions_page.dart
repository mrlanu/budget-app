import 'package:budget_app/transactions/repository/transactions_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../app/bloc/app_bloc.dart';
import '../../shared/widgets/entity_view_widget.dart';
import '../cubit/transactions_cubit.dart';

class TransactionsPage extends StatelessWidget {
  static const routeName = '/transactions';

  static Route<void> route(
      {required String categoryId, required DateTime dateTime}) {
    return MaterialPageRoute(builder: (context) {
      final appBloc = BlocProvider.of<AppBloc>(context);
      return BlocProvider(
        create: (context) => TransactionsCubit(
            transactionsRepository: TransactionRepositoryImpl(
          user: appBloc.state.user,
        ))
          ..fetchTransactions(categoryId: categoryId, date: dateTime),
        child: TransactionsPage(),
      );
    });
  }

  const TransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsCubit, TransactionsState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Transactions'),
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
                          subtitlePrefix:
                              DateFormat('MM-dd-yyyy').format(tr.date),
                          routeName: '',
                          amount: tr.amount.toString(),
                          suffix: Icon(Icons.chevron_right),
                          onTap: () => {});
                    }));
      },
    );
  }
}
