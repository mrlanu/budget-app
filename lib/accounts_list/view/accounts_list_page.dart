import 'package:budget_app/transaction/repository/budget_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../utils/theme/budget_theme.dart';
import '../../utils/theme/cubit/theme_cubit.dart';
import '../cubit/accounts_cubit.dart';

class AccountsListPage extends StatelessWidget {
  const AccountsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AccountsCubit(budgetRepository: context.read<BudgetRepository>()),
      child: AccountsListView(),
    );
  }
}

class AccountsListView extends StatelessWidget {
  const AccountsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<AccountsCubit, AccountsState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == AccountsStatus.failure) {
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
        child: BlocBuilder<AccountsCubit, AccountsState>(
          builder: (context, state) {
            final themeState = context.watch<ThemeCubit>().state;
            return Scaffold(
              appBar: AppBar(
                title: Text('Accounts'),
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    context.pop();
                  },
                ),
              ),
              body: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.accountList.length,
                      itemBuilder: (context, index) {
                        final account = state.accountList[index];
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
                                    color: themeState.primaryColor[900],
                                    IconData(
                                        state.accountCategories
                                            .firstWhere((element) =>
                                                element.id ==
                                                account.category.value?.id)
                                            .iconCode,
                                        fontFamily: 'FontAwesomeSolid')),
                              ],
                            ),
                            leading: IconButton(
                              icon: Icon(Icons.highlight_remove,
                                  color: Theme.of(context).colorScheme.error),
                              onPressed: () {
                                context
                                    .read<AccountsCubit>()
                                    .onAccountDeleted(account);
                              },
                            ),
                            trailing: Icon(Icons.chevron_right),
                            onTap: () {
                              context.push('/accounts-list/edit/${account.id}');
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  ListTile(
                    tileColor: BudgetTheme.isDarkMode(context)
                        ? themeState.secondaryColor
                        : themeState.secondaryColor,
                    title: Text(
                      'Add Account',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: BudgetTheme.isDarkMode(context)
                                ? themeState.primaryColor[900]
                                : themeState.primaryColor[100],
                          ),
                    ),
                    trailing: Icon(
                      Icons.add,
                      color: BudgetTheme.isDarkMode(context)
                          ? themeState.primaryColor[900]
                          : themeState.primaryColor[100],
                    ),
                    onTap: () {
                      //context.read<AccountsListCubit>().onNewAccount();
                      context.push('/accounts-list/new');
                    },
                  ),
                ],
              ),
            );
          },
        ));
  }
}
