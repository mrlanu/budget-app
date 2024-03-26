import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../budgets/budgets.dart';
import '../../constants/colors.dart';
import '../../utils/theme/budget_theme.dart';
import '../account_edit/bloc/account_edit_bloc.dart';
import '../account_edit/view/account_edit_form.dart';
import '../cubit/accounts_cubit.dart';

class AccountsListPage extends StatelessWidget {
  const AccountsListPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return BlocProvider(
                create: (context) => AccountsCubit(
                  budgetRepository: context.read<BudgetRepository>()
                ),
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
            final scheme = Theme.of(context).colorScheme;
            return Scaffold(
              appBar: AppBar(
                title: Text('Accounts'),
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
                                    color: scheme.primary,
                                    IconData(
                                        state.accountCategories
                                                .firstWhere((element) =>
                                                    element.id ==
                                                    account.categoryId)
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
                              _openDialog(context: context, account: account);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  ListTile(
                    tileColor: BudgetTheme.isDarkMode(context)
                        ? BudgetColors.accentDark
                        : BudgetColors.accent,
                    title: Text(
                      'Add Account',
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleLarge!.fontSize),
                    ),
                    trailing: Icon(
                      Icons.add,
                      color: BudgetColors.primary,
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
                create: (context) => AccountEditBloc(budgetRepository: context.read<BudgetRepository>())
                  ..add(AccountEditFormLoaded(account: account)),
                child: AccountEditDialog(),
              ));
}
