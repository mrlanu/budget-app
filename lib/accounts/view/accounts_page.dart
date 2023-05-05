import 'package:budget_app/accounts/cubit/accounts_cubit.dart';
import 'package:budget_app/accounts/repository/spring_accounts_api.dart';
import 'package:budget_app/app/app.dart';
import 'package:budget_app/shared/shared.dart';
import 'package:budget_app/shared/widgets/entity_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AccountsPage extends StatelessWidget {

  const AccountsPage({Key? key}) : super(key: key);

  static const routeName = '/accounts';

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return BlocProvider(
      create: (context) =>
          AccountsCubit(SpringAccountsApi(user: user))..fetchAllAccounts(),
      child: Scaffold(
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
                          onTap: (){},
                        );
                      });
            },
          )),
    );
  }
}