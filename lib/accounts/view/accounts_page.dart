import 'package:budget_app/accounts/cubit/accounts_cubit.dart';
import 'package:budget_app/accounts/repository/accounts_repository.dart';
import 'package:budget_app/app/app.dart';
import 'package:budget_app/home/cubit/home_cubit.dart';
import 'package:budget_app/shared/shared.dart';
import 'package:budget_app/transactions/models/transactions_view_filter.dart';
import 'package:budget_app/transactions/repository/transactions_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../transactions/view/transactions_page.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({Key? key}) : super(key: key);

  static const routeName = '/accounts';

  static Route<void> route(
      {required HomeCubit homeCubit,
      required String categoryId,
      required DateTime dateTime}) {
    return MaterialPageRoute(builder: (context) {
      final appBloc = BlocProvider.of<AppBloc>(context);
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AccountsCubit(
                budgetId: appBloc.state.budget!.id,
                categoryId: categoryId,
                transactionsRepository:
                    context.read<TransactionsRepositoryImpl>(),
                accountsRepository: context.read<AccountsRepositoryImpl>())
              ..fetchAllAccounts(),
          ),
          BlocProvider.value(value: homeCubit),
        ],
        child: AccountsPage(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
        appBar: AppBar(
          title: Text('Accounts'),
          centerTitle: true,
        ),
        body: BlocBuilder<AccountsCubit, AccountsState>(
            builder: (context, state) {
          return state.status == DataStatus.loading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: state.accountList.length,
                  itemBuilder: (context, index) {
                    final acc = state.accountList[index];
                    return Card(
                      margin: EdgeInsets.symmetric(
                          horizontal: 30.w, vertical: 15.h),
                      elevation: Theme.of(context).cardTheme.elevation,
                      child: ListTile(
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '\$ ${acc.balance.toString()}',
                                style: TextStyle(
                                    fontSize: textTheme.titleLarge!.fontSize,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 30.w,
                              ),
                              Icon(Icons.chevron_right),
                            ],
                          ),
                          title: Text(
                            acc.name,
                            style: TextStyle(
                                fontSize: textTheme.titleLarge!.fontSize),
                          ),
                          onTap: () =>
                              Navigator.of(context).push(TransactionsPage.route(
                                homeCubit: context.read<HomeCubit>(),
                                filter: TransactionsViewFilter(
                                    type: TransactionsViewFilterTypes.accountId,
                                    filterId: acc.id!),
                              ))),
                    );
                  });
        }));
  }
}
