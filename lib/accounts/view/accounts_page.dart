import 'package:budget_app/accounts/cubit/accounts_cubit.dart';
import 'package:budget_app/accounts/repository/accounts_repository.dart';
import 'package:budget_app/app/app.dart';
import 'package:budget_app/home/cubit/home_cubit.dart';
import 'package:budget_app/shared/shared.dart';
import 'package:budget_app/shared/widgets/entity_view_widget.dart';
import 'package:budget_app/transactions/repository/transactions_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../transactions/view/transactions_page.dart';

class AccountsPage extends StatelessWidget {

  const AccountsPage({Key? key}) : super(key: key);

  static const routeName = '/accounts';

  static Route<void> route(
      {required HomeCubit homeCubit, required String categoryId, required DateTime dateTime}) {
    return MaterialPageRoute(builder: (context) {
      final appBloc = BlocProvider.of<AppBloc>(context);
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
            AccountsCubit(
                accountsRepository: AccountsRepositoryImpl(
                  user: appBloc.state.user,))
              ..fetchAllAccounts(
                  budgetId: appBloc.state.budget!.id, categoryId: categoryId),
          ),
          BlocProvider.value(value: homeCubit),
        ],
        child: AccountsPage(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Accounts'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
          },
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<AccountsCubit, AccountsState>(
            builder: (context, state) {
              return state.status == DataStatus.loading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                  itemCount: state.accountList.length,
                  itemBuilder: (context, index) {
                    final acc = state.accountList[index];
                    return EntityView(
                      title: acc.name,
                      routeName: acc.name,
                      //subtitle: 'subtitle',
                      amount: acc.balance.toString(),
                      suffix: Icon(Icons.chevron_right),
                      onTap: () =>
                          Navigator.of(context).push(TransactionsPage.route(
                              homeCubit: context.read<HomeCubit>(),
                              filterBy: TransactionsFilter.account,
                              filterId: acc.id!,
                              dateTime: DateTime.now())),
                    );
                  });
            }));
  }
}
