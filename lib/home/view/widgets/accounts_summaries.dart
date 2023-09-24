import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/home/cubit/home_cubit.dart' as homeCubit;
import 'package:budget_app/transactions/cubit/transactions_cubit.dart';
import 'package:budget_app/transfer/bloc/transfer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../accounts/cubit/accounts_cubit.dart';
import '../../../accounts/models/accounts_view_filter.dart';
import '../../../colors.dart';
import '../../../constants/constants.dart';
import '../../../transactions/models/transactions_view_filter.dart';
import '../../../transactions/view/transactions_list.dart';

class AccountsSummaries extends StatelessWidget {
  AccountsSummaries({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountsCubit(
          filter: AccountsViewFilter(filterId: ''),
          budgetRepository: context.read<BudgetRepository>()),
      child: AccountsSummariesView(),
    );
  }
}

class AccountsSummariesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return MultiBlocListener(
        listeners: [
          BlocListener<homeCubit.HomeCubit, homeCubit.HomeState>(
            listenWhen: (previous, current) => previous.tab != current.tab,
            listener: (context, state) {
              BlocProvider.of<TransactionsCubit>(context)
                  .setTab(state.tab.index);
            },
          ),
          BlocListener<homeCubit.HomeCubit, homeCubit.HomeState>(
            listenWhen: (previous, current) =>
                previous.selectedDate != current.selectedDate,
            listener: (context, state) {
              BlocProvider.of<TransactionsCubit>(context)
                  .changeDate(state.selectedDate!);
            },
          ),
        ],
        child: SingleChildScrollView(
            child: BlocBuilder<AccountsCubit, AccountsState>(
          builder: (context, state) {
            return ExpansionPanelList(
              dividerColor: BudgetColors.teal900,
              expansionCallback: (int index, bool isExpanded) {
                context.read<AccountsCubit>().changeExpanded(index);
                if (isDisplayDesktop(context)) {
                  context.read<TransferBloc>().add(TransferFormLoaded());
                }
              },
              children: state.accountList.map<ExpansionPanel>((acc) {
                return ExpansionPanel(
                    canTapOnHeader: true,
                    backgroundColor: BudgetColors.teal100,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        leading: Builder(builder: (context) {
                          final categories =
                              context.read<BudgetRepository>().getCategories();
                          return FaIcon(
                              color: scheme.primary,
                              IconData(
                                  categories
                                      .firstWhere((element) =>
                                          element.id == acc.categoryId)
                                      .iconCode,
                                  fontFamily: 'FontAwesomeSolid'));
                        }),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '\$ ${acc.balance.toStringAsFixed(2)}',
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
        )));
  }
}
