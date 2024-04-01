import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../budgets/budgets.dart';
import '../../constants/colors.dart';
import '../../utils/theme/budget_theme.dart';
import '../cubit/subcategories_cubit.dart';

class SubcategoriesPage extends StatelessWidget {
  const SubcategoriesPage({Key? key, required this.category}) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubcategoriesCubit(
          budgetRepository: context.read<BudgetRepository>(),
          category: category)
        ..onInit(category: category),
      child: SubcategoriesView(),
    );
  }
}

class SubcategoriesView extends StatelessWidget {
  const SubcategoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubcategoriesCubit, SubcategoriesState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == SubcategoriesStatus.failure) {
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
            title: _buildTitle(state.category!),
          ),
          body: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.subcategories.length,
                  itemBuilder: (context, index) {
                    final subcategory = state.subcategories[index];
                    return Card(
                      elevation: Theme.of(context).cardTheme.elevation,
                      child: ListTile(
                        title: Text(
                          subcategory.name,
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .fontSize),
                        ),
                        leading: IconButton(
                          icon: Icon(Icons.highlight_remove,
                              color: Theme.of(context).colorScheme.error),
                          onPressed: () {
                            context
                                .read<SubcategoriesCubit>()
                                .onSubcategoryDeleted(subcategory);
                          },
                        ),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          context.push('/subcategories/edit/${subcategory.id}'
                              '?categoryId=${state.category!.id}');
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
                  'New Subcategory',
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleLarge!.fontSize),
                ),
                trailing: Icon(
                  Icons.add,
                  color: BudgetColors.primary,
                ),
                onTap: () => context.push(
                    '/subcategories/new?categoryId=${state.category!.id}'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle(Category category) {
    final body = 'Subcategories for ${category.name}';
    return Text(body);
  }
}
