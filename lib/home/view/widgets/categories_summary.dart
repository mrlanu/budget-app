import 'package:budget_app/transactions/view/transactions_page.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/entity_view_widget.dart';
import '../../../shared/models/category_summary.dart';

class CategoriesSummary extends StatelessWidget {
  final List<CategorySummary> categorySummaryList;
  final DateTime? dateTime;

  const CategoriesSummary(
      {Key? key, required this.categorySummaryList, this.dateTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: categorySummaryList.length,
        itemBuilder: (context, index) {
          final catSection = categorySummaryList[index];
          return EntityView(
            icon: Icon(IconData(catSection.iconCodePoint,
                fontFamily: 'MaterialIcons')),
            title: catSection.category.name,
            routeName: catSection.category.name,
            //subtitle: 'subtitle',
            amount: catSection.amount,
            suffix: Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context)
                .pushNamed(TransactionsPage.routeName, arguments: {
              'category': catSection.category,
              'date': dateTime ?? DateTime.now(),
            }),
          );
        });
  }
}
