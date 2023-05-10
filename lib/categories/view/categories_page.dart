import 'package:budget_app/categories/cubit/categories_cubit.dart';
import 'package:budget_app/paginator/month_paginator.dart';
import 'package:budget_app/shared/repositories/shared_repository.dart';
import 'package:budget_app/transactions/view/transactions_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/shared.dart';
import '../../shared/widgets/entity_view_widget.dart';
import '../../transactions/transaction/view/transaction_page.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  static const routeName = '/categories';

  @override
  Widget build(BuildContext context) {
    final section =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: MonthPaginator(
          onLeft: (value) => print('On left: $value'),
          onRight: (value) => print('On right: $value'),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(TransactionPage.routeName);
            },
          )
        ],
      ),
      body: BlocProvider(
        create: (context) =>
            CategoriesCubit(context.read<SharedRepositoryImpl>())
              ..fetchAllCategories(section['section']!),
        child: BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
            return state.status == DataStatus.loading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: state.categorySummaryList.length,
                    itemBuilder: (context, index) {
                      final cat = state.categorySummaryList[index];
                      return EntityView(
                        icon: Icon(IconData(cat.iconCodePoint,
                            fontFamily: 'MaterialIcons')),
                        title: cat.category.name,
                        routeName: cat.category.name,
                        //subtitle: 'subtitle',
                        amount: cat.amount,
                        suffix: Icon(Icons.chevron_right),
                        onTap: () => Navigator.of(context)
                            .pushNamed(TransactionsPage.routeName, arguments: {
                          "category": cat.category,
                        }),
                      );
                    });
          },
        ),
      ),
    );
  }
}
