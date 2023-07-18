import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../accounts/cubit/accounts_cubit.dart';
import '../../../accounts/models/accounts_view_filter.dart';
import '../../../accounts/repository/accounts_repository.dart';
import '../../../colors.dart';
import '../../../transactions/models/transactions_view_filter.dart';
import '../../../transactions/repository/transactions_repository.dart';
import '../../../transactions/view/transactions_list.dart';

class AccountsSummaries extends StatelessWidget {
  AccountsSummaries({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountsCubit(
          filter: AccountsViewFilter(filterId: ''),
          transactionsRepository: context.read<TransactionsRepositoryImpl>(),
          accountsRepository: context.read<AccountsRepositoryImpl>())
        ..fetchAllAccounts(),
      child: AccountsSummariesView(),
    );
  }
}

class AccountsSummariesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
        child: BlocBuilder<AccountsCubit, AccountsState>(
      builder: (context, state) {
        return ExpansionPanelList(
          dividerColor: BudgetColors.teal900,
          expansionCallback: (int index, bool isExpanded) {
            context.read<AccountsCubit>().changeExpanded(index);
          },
          children: state.accountList.map<ExpansionPanel>((acc) {
            return ExpansionPanel(
                canTapOnHeader: true,
                backgroundColor: BudgetColors.teal100,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    leading: Icon(Icons.account_balance_outlined,
                        color: scheme.primary),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$ ${acc.balance.toString()}',
                          style: TextStyle(
                              fontSize: textTheme.titleLarge!.fontSize,
                              fontWeight: FontWeight.bold,
                              color: scheme.primary),
                        ),
                      ],
                    ),
                    title: Text(
                      acc.name,
                      style: TextStyle(
                          fontSize: textTheme.titleLarge!.fontSize,
                          fontWeight: FontWeight.bold,
                          color: scheme.primary),
                    ),
                  );
                },
                body: TransactionsList(
                    filter: TransactionsViewFilter(
                        type: TransactionsViewFilterTypes.accountId,
                        filterId: acc.id)),
                isExpanded: acc.isExpanded);
          }).toList(),
        );
      },
    ));
  }
}
