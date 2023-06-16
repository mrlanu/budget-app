import 'package:budget_app/accounts/view/accounts_page.dart';
import 'package:budget_app/home/cubit/home_cubit.dart';
import 'package:budget_app/shared/models/summary_by.dart';
import 'package:budget_app/transactions/repository/transactions_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../transactions/view/transactions_page.dart';

class CategoriesSummary extends StatelessWidget {
  final List<SummaryBy> summaryList;
  final DateTime? dateTime;

  const CategoriesSummary(
      {Key? key,
      required this.summaryList,
      this.dateTime,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final showHeader = state.tab.index != 2;
        return Column(
          children: [
            (showHeader && summaryList.length > 0)
                ? HeaderTile(data: summaryList[0], dateTime: dateTime!)
                : Container(),
            Expanded(
              child: ListView.builder(
                  itemCount:
                      showHeader && summaryList.length > 0 ? summaryList.length - 1 : summaryList.length,
                  itemBuilder: (context, index) {
                    final summaryItem = showHeader
                        ? summaryList[index + 1]
                        : summaryList[index];
                    return Card(
                      margin: EdgeInsets.symmetric(
                          horizontal: 30.w, vertical: 15.h),
                      elevation: Theme.of(context).cardTheme.elevation,
                      child: ListTile(
                          leading: Icon(IconData(summaryItem.iconCodePoint,
                              fontFamily: 'MaterialIcons')),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '\$ ${summaryItem.total.toString()}',
                                style: TextStyle(
                                    fontSize: textTheme.titleLarge!.fontSize,
                                    fontWeight: FontWeight.bold),
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
                            ),
                          ),
                          onTap: state.tab == HomeTab.accounts
                              ? () => Navigator.of(context).push(
                                  AccountsPage.route(
                                      homeCubit: BlocProvider.of<HomeCubit>(context),
                                      categoryId: summaryItem.id,
                                      dateTime: dateTime ?? DateTime.now()))
                              : () => Navigator.of(context).push(
                                  TransactionsPage.route(
                                      homeCubit: BlocProvider.of<HomeCubit>(context),
                                      filterBy: TransactionsFilter.category,
                                      filterId: summaryItem.id,
                                      filterDate: dateTime ?? DateTime.now()))),
                    );
                  }),
            ),
          ],
        );
      },
    );
  }
}

class HeaderTile extends StatelessWidget {
  final SummaryBy data;
  final DateTime dateTime;

  const HeaderTile({super.key, required this.data, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<HomeCubit, HomeState>(
  builder: (context, state) {
    return Column(
      children: [
        Divider(endIndent: 30.w, indent: 30.w),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
          elevation: Theme.of(context).cardTheme.elevation,
          child: ListTile(
              leading: Icon(
                  IconData(data.iconCodePoint, fontFamily: 'MaterialIcons')),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$ ${data.total.toString()}',
                    style: TextStyle(
                        fontSize: textTheme.titleLarge!.fontSize,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 30.w,
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
              title: Text(
                data.name,
                style: TextStyle(
                  fontSize: textTheme.titleLarge!.fontSize,
                ),
              ),
              onTap: () => Navigator.of(context).push(TransactionsPage.route(
                      homeCubit: BlocProvider.of<HomeCubit>(context),
                      filterBy: TransactionsFilter.category,
                      filterId: state.tab.index == 0 ? 'all_expenses' : 'all_incomes',
                      filterDate: dateTime))),
        ),
        Divider(endIndent: 30.w, indent: 30.w)
      ],
    );
  },
);
  }
}
