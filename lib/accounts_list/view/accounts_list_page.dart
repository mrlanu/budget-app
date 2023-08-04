import 'package:budget_app/account_edit/bloc/account_edit_bloc.dart';
import 'package:budget_app/account_edit/view/account_edit_form.dart';
import 'package:budget_app/accounts/repository/accounts_repository.dart';
import 'package:budget_app/colors.dart';
import 'package:budget_app/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../accounts/models/account.dart';
import '../../categories/repository/categories_repository.dart';
import '../cubit/accounts_list_cubit.dart';

class AccountsListPage extends StatelessWidget {
  const AccountsListPage({Key? key}) : super(key: key);

  static Route<void> route({required HomeCubit homeCubit}) {
    return MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => AccountsListCubit(
                  accountsRepository: context.read<AccountsRepositoryImpl>(),
                  categoriesRepository:
                      context.read<CategoriesRepositoryImpl>(),
                )..onInit(),
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
            final scheme = Theme.of(context).colorScheme;
            return Scaffold(
              appBar: AppBar(
                title: Text('Accounts'),
              ),
              body: Column(
                children: [
                  SizedBox(
                    height: 50.h,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.accounts.length,
                      itemBuilder: (context, index) {
                        final account = state.accounts[index];
                        return Card(
                          elevation: Theme.of(context).cardTheme.elevation,
                          child: ListTile(
                            title: Row(
                              children: [
                                Text(
                                  account.extendName(state.accountCategories),
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .fontSize),
                                ),
                                Expanded(child: Container()),
                                FaIcon(
                                    color: scheme.primary,
                                    IconData(
                                        state.accountCategories
                                                .firstWhere((element) =>
                                                    element.id ==
                                                    account.categoryId)
                                                .iconCode ??
                                            0,
                                        fontFamily: 'FontAwesomeSolid')),
                              ],
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
                          ),
                        );
                      },
                    ),
                  ),
                  ListTile(
                    tileColor: BudgetColors.amber800,
                    title: Text(
                      'Add Account',
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleLarge!.fontSize),
                    ),
                    trailing: Icon(
                      Icons.add,
                      color: BudgetColors.teal900,
                    ),
                    onTap: () {
                      //context.read<AccountsListCubit>().onNewAccount();
                      _openDialog(context: context);
                    },
                  ),
                ],
              ),
            );
          },
        ));
  }

  Future<String?> _openDialog(
          {required BuildContext context, Account? account}) =>
      showDialog<String>(
          context: context,
          builder: (_) => BlocProvider(
                create: (context) => AccountEditBloc(
                    categoriesRepository:
                        context.read<CategoriesRepositoryImpl>(),
                    accountsRepository: context.read<AccountsRepositoryImpl>())
                  ..add(AccountEditFormLoaded(account: account)),
                child: AccountEditDialog(),
              ));
}
