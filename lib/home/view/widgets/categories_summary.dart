import 'package:budget_app/accounts/view/accounts_page.dart';
import 'package:budget_app/home/cubit/home_cubit.dart';
import 'package:budget_app/shared/models/summary_tile.dart';
import 'package:budget_app/transactions/models/transactions_view_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../transactions/view/transactions_page.dart';

class CategoriesSummary extends StatelessWidget {
  final List<SummaryTile> summaryList;
  final DateTime? dateTime;

  const CategoriesSummary({
    Key? key,
    required this.summaryList,
    this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              height: 50.h,
            ),
            Expanded(
              child: ListView.separated(
                  itemCount: summaryList.length,
                  separatorBuilder: (context, index) => SizedBox(
                        height: 15.h,
                      ),
                  itemBuilder: (context, index) {
                    final summaryItem = summaryList[index];
                    return Card(
                      margin: EdgeInsets.symmetric(
                          horizontal: 30.w, vertical: 15.h),
                      elevation: Theme.of(context).cardTheme.elevation,
                      child: ListTile(
                          leading: Icon(
                              color: scheme.primary,
                              IconData(summaryItem.iconCodePoint,
                                  fontFamily: 'MaterialIcons')),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '\$ ${summaryItem.total.toString()}',
                                style: TextStyle(
                                    fontSize: textTheme.titleLarge!.fontSize,
                                    fontWeight: FontWeight.bold,
                                    color: scheme.primary),
                              ),
                              SizedBox(
                                width: 30.w,
                              ),
                              Icon(Icons.chevron_right),
                            ],
                          ),
                          title: Text(
                            summaryItem.name,
                            style: TextStyle(
                                fontSize: textTheme.titleLarge!.fontSize,
                                color: scheme.primary),
                          ),
                          onTap: state.tab == HomeTab.accounts
                              ? () => Navigator.of(context).push(
                                  AccountsPage.route(
                                      homeCubit:
                                          BlocProvider.of<HomeCubit>(context),
                                      categoryId: summaryItem.id,
                                      dateTime: dateTime ?? DateTime.now()))
                              : () => Navigator.of(context)
                                      .push(TransactionsPage.route(
                                    homeCubit:
                                        BlocProvider.of<HomeCubit>(context),
                                    filter: index == 0
                                        ? TransactionsViewFilter(
                                            type: state.tab.index == 0
                                                ? TransactionsViewFilterTypes
                                                    .allExpenses
                                                : TransactionsViewFilterTypes
                                                    .allIncomes)
                                        : TransactionsViewFilter(
                                            type: TransactionsViewFilterTypes
                                                .categoryId,
                                            filterId: summaryItem.id),
                                  ))),
                    );
                  }),
            ),
          ],
        );
      },
    );
  }
}
