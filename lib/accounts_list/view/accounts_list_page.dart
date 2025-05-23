import 'package:qruto_budget/accounts_list/repository/account_repository.dart';
import 'package:qruto_budget/categories/repository/category_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../shared/shared.dart';
import '../../utils/theme/budget_theme.dart';
import '../../utils/theme/cubit/theme_cubit.dart';
import '../cubit/accounts_cubit.dart';

class AccountsListPage extends StatelessWidget {
  const AccountsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountsCubit(
          accountRepository: context.read<AccountRepository>(),
          categoryRepository: context.read<CategoryRepository>()),
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
                SharedFunctions.showSnackbar(
                    context, false, 'Ups', state.errorMessage!);
              }
            },
          ),
        ],
        child: BlocBuilder<AccountsCubit, AccountsState>(
          builder: (context, state) {
            final themeState = context.watch<ThemeCubit>().state;
            return Scaffold(
              appBar: AppBar(
                title: Text('Accounts', style: TextStyle(fontSize: 30.sp)),
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    context.pop();
                  },
                ),
              ),
              body: Column(
                children: [
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.accountList.length,
                      itemBuilder: (context, index) {
                        final account = state.accountList[index];
                        return Card(
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.highlight_remove,
                                    color: Theme.of(context).colorScheme.error),
                                onPressed: () {
                                  context
                                      .read<AccountsCubit>()
                                      .onAccountDeleted(account);
                                },
                              ),
                              Text(
                                overflow: TextOverflow.ellipsis,
                                account.extendName(),
                                style: TextStyle(
                                    color: BudgetTheme.isDarkMode(context)
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              FaIcon(
                                  color: BudgetTheme.isDarkMode(context)
                                      ? Colors.white
                                      : themeState.primaryColor[700],
                                  IconData(account.category.iconCode,
                                      fontFamily: 'FontAwesomeSolid')),
                              IconButton(
                                onPressed: () => context
                                    .push('/accounts-list/edit/${account.id}'),
                                icon: Icon(Icons.chevron_right),
                              )
                            ],
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
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(
                      Icons.add,
                      color: Colors.white,
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
