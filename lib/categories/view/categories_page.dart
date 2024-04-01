import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/categories/cubit/categories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../constants/colors.dart';
import '../../transaction/models/transaction_type.dart';
import '../../utils/theme/budget_theme.dart';

class CategoriesPage extends StatelessWidget {
  CategoriesPage({Key? key, required this.transactionType}) : super(key: key);

  final TransactionType transactionType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesCubit(
          budgetRepository: context.read<BudgetRepository>(),
          transactionType: transactionType),
      child: CategoriesView(),
    );
  }
}

class CategoriesView extends StatelessWidget {
  const CategoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocConsumer<CategoriesCubit, CategoriesState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == CategoriesStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
              ),
            );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: _buildTitle(state),
          ),
          body: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    return Card(
                      elevation: Theme.of(context).cardTheme.elevation,
                      child: ListTile(
                        title: Row(
                          children: [
                            Text(
                              category.name,
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .fontSize),
                            ),
                            Expanded(child: Container()),
                            FaIcon(
                                color: scheme.primary,
                                IconData(category.iconCode,
                                    fontFamily: 'FontAwesomeSolid')),
                          ],
                        ),
                        leading: IconButton(
                          icon: Icon(Icons.highlight_remove,
                              color: Theme.of(context).colorScheme.error),
                          onPressed: () {
                            context
                                .read<CategoriesCubit>()
                                .onCategoryDeleted(category);
                          },
                        ),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          context.push('/categories/edit/${category.id}');
                        },
                      ),
                    );
                  },
                ),
              ),
              ListTile(
                tileColor: BudgetTheme.isDarkMode(context)
                    ? BudgetColors.accentDark
                    : BudgetColors.accent,
                title: Text(
                  'Add category',
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleLarge!.fontSize),
                ),
                trailing: Icon(
                  Icons.add,
                  color: BudgetColors.primary,
                ),
                onTap: () {
                  context.push('/categories/new');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle(CategoriesState state) {
    final body = switch (state.transactionType) {
      TransactionType.EXPENSE => 'Expenses categories',
      TransactionType.INCOME => 'Income categories',
      TransactionType.TRANSFER => 'Transfer',
      TransactionType.ACCOUNT => 'Account categories',
    };
    return Text(body);
  }
}
