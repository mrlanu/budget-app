import 'package:budget_app/account_edit/bloc/account_edit_bloc.dart';
import 'package:budget_app/account_edit/view/account_edit_form.dart';
import 'package:budget_app/accounts/repository/accounts_repository.dart';
import 'package:budget_app/app/app.dart';
import 'package:budget_app/categories/models/category.dart';
import 'package:budget_app/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../accounts/models/account.dart';
import '../../categories/repository/categories_repository.dart';
import '../cubit/accounts_list_cubit.dart';

class AccountsListPage extends StatelessWidget {
  const AccountsListPage({Key? key}) : super(key: key);

  static Route<void> route(
      {required HomeCubit homeCubit,
      required List<Category> accountCategories}) {
    return MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => AccountsListCubit(
                  accountsRepository: context.read<AccountsRepositoryImpl>(),
                  accountCategories: accountCategories,
                )..onInit(budgetId: context.read<AppBloc>().state.budget!.id),
              ),
              BlocProvider.value(value: homeCubit),
            ],
            child: AccountsListPage(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return const AccountsListView();
  }
}

class AccountsListView extends StatelessWidget {
  const AccountsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MultiBlocListener(
        listeners: [
          BlocListener<AccountsListCubit, AccountsListState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == AccountsListStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage!),
                    ),
                  );
              }
            },
          ),
        ],
        child: BlocBuilder<AccountsListCubit, AccountsListState>(
          builder: (context, state) {
            return Container(
              color: scheme.background,
              child: SafeArea(
                  child: Scaffold(
                appBar: AppBar(
                  title: Text('Accounts'),
                ),
                body: Column(
                  children: [
                    Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.accounts.length,
                        itemBuilder: (context, index) {
                          final account = state.accounts[index];
                          return ListTile(
                            title: Text(
                              account.extendName(state.accountCategories),
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .fontSize),
                            ),
                            leading: IconButton(
                              icon: Icon(Icons.highlight_remove,
                                  color: Theme.of(context).colorScheme.error),
                              onPressed: () {
                                context
                                    .read<AccountsListCubit>()
                                    .onAccountDeleted(account);
                              },
                            ),
                            trailing: Icon(Icons.chevron_right),
                            onTap: () {
                              _openDialog(context: context, account: account);
                            },
                          );
                        },
                      ),
                    ),
                    ListTile(
                      tileColor: scheme.secondaryContainer,
                      title: Text(
                        'New Account',
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .fontSize),
                      ),
                      trailing: Icon(
                        Icons.add,
                        color: scheme.onSecondaryContainer,
                      ),
                      onTap: () {
                        //context.read<AccountsListCubit>().onNewAccount();
                        _openDialog(context: context);
                      },
                    ),
                  ],
                ),
              )),
            );
          },
        ));
  }

  Future<String?> _openDialog({required BuildContext context, Account? account}) => showDialog<String>(
      context: context,
      builder: (_) => BlocProvider(
            create: (context) => AccountEditBloc(
                budgetId: context.read<AppBloc>().state.budget!.id,
                categoriesRepository: context.read<CategoriesRepositoryImpl>(),
                accountsRepository: context.read<AccountsRepositoryImpl>())
              ..add(AccountEditFormLoaded(account: account)),
            child: AccountEditDialog(),
          ));
}
