import 'package:budget_app/accounts/view/accounts_page.dart';
import 'package:budget_app/home/cubit/home_cubit.dart';
import 'package:budget_app/shared/models/summary_by.dart';
import 'package:budget_app/transactions/repository/transactions_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/widgets/entity_view_widget.dart';
import '../../../transactions/view/transactions_page.dart';

class CategoriesSummary extends StatelessWidget {
  final List<SummaryBy> summaryList;
  final DateTime? dateTime;

  const CategoriesSummary({Key? key, required this.summaryList, this.dateTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeCubit = BlocProvider.of<HomeCubit>(context);
    return ListView.builder(
        itemCount: summaryList.length,
        itemBuilder: (context, index) {
          final summaryItem = summaryList[index];
          return EntityView(
              icon: Icon(IconData(summaryItem.iconCodePoint,
                  fontFamily: 'MaterialIcons')),
              title: summaryItem.name,
              routeName: summaryItem.name,
              amount: summaryItem.total.toString(),
              suffix: Icon(Icons.chevron_right),
              onTap: homeCubit.state.tab == HomeTab.accounts
                  ? () => Navigator.of(context).push(AccountsPage.route(homeCubit: homeCubit,
                      categoryId: summaryItem.id,
                      dateTime: dateTime ?? DateTime.now()))
                  : () => Navigator.of(context).push(TransactionsPage.route(homeCubit: homeCubit,
                filterBy: TransactionsFilter.category,
                      filterId: summaryItem.id,
                      filterDate: dateTime ?? DateTime.now())));
        });
  }
}
