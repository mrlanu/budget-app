import 'package:budget_app/home/cubit/home_cubit.dart';
import 'package:budget_app/transactions/view/transactions_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/shared.dart';
import '../../shared/widgets/entity_view_widget.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      return state.status == DataStatus.loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: state.categorySummaryList.length,
              itemBuilder: (context, index) {
                final catSection = state.categorySummaryList[index];
                return EntityView(
                  icon: Icon(
                      IconData(catSection.iconCodePoint, fontFamily: 'MaterialIcons')),
                  title: catSection.category.name,
                  routeName: catSection.category.name,
                  //subtitle: 'subtitle',
                  amount: catSection.amount,
                  suffix: Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context)
                      .pushNamed(TransactionsPage.routeName, arguments: {
                    'category': catSection.category, 'date': state.selectedDate ?? DateTime.now(),
                  }),
                );
              });
    });
  }
}
