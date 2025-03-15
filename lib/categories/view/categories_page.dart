import 'package:budget_app/categories/cubit/categories_cubit.dart';
import 'package:budget_app/categories/repository/category_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../transaction/models/transaction_type.dart';
import '../../utils/theme/budget_theme.dart';
import '../../utils/theme/cubit/theme_cubit.dart';

class CategoriesPage extends StatelessWidget {
  CategoriesPage({Key? key, required this.transactionType}) : super(key: key);

  final TransactionType transactionType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesCubit(
          categoryRepository: context.read<CategoryRepository>(),
          transactionType: transactionType),
      child: CategoriesView(),
    );
  }
}

class CategoriesView extends StatelessWidget {
  const CategoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeCubit>().state;
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
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                context.pop();
              },
            ),
          ),
          body: Column(
            children: [
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: state.filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = state.filteredCategories[index];
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
                                color: themeState.primaryColor[900],
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
                          context.push('/categories/edit/${category.id}?'
                              'typeIndex=${state.transactionType.index}');
                        },
                      ),
                    );
                  },
                ),
              ),
              ListTile(
                tileColor: BudgetTheme.isDarkMode(context)
                    ? themeState.secondaryColor
                    : themeState.secondaryColor,
                title: Text(
                  'Add Category',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: BudgetTheme.isDarkMode(context)
                            ? themeState.primaryColor[900]
                            : themeState.primaryColor[100],
                      ),
                ),
                trailing: Icon(
                  Icons.add,
                  color: BudgetTheme.isDarkMode(context)
                      ? themeState.primaryColor[900]
                      : themeState.primaryColor[100],
                ),
                onTap: () {
                  context.push(
                      '/categories/new?typeIndex=${state.transactionType.index}');
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
