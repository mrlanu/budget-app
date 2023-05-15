import 'package:budget_app/categories/cubit/categories_cubit.dart';
import 'package:budget_app/shared/repositories/shared_repository.dart';
import 'package:budget_app/transactions/view/transactions_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/widgets/entity_view_widget.dart';

class CategoriesPage extends StatelessWidget {
  final String budgetId;
  final String section;

  const CategoriesPage(
      {Key? key,
      required this.budgetId,
      required this.section,
      DateTime? selectedDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesCubit(
          sharedRepository: context.read<SharedRepositoryImpl>(),
          section: section)..subscriptionRequested(),
      child: CategoriesView(),
    );
  }
}

class CategoriesView extends StatelessWidget {
  const CategoriesView({Key? key, this.selectedDate}) : super(key: key);

  final DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        return state.status == CategoriesStatus.loading
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: state.categorySummaryList.length,
                itemBuilder: (context, index) {
                  final catSection = state.categorySummaryList[index];
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
                      'date': selectedDate ?? DateTime.now(),
                    }),
                  );
                });
      },
    );
  }
}
