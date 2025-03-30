import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qruto_budget/categories/repository/category_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../constants/colors.dart';
import '../../database/database.dart';
import '../../shared/shared.dart';
import '../../utils/theme/budget_theme.dart';
import '../../utils/theme/cubit/theme_cubit.dart';
import '../cubit/subcategories_cubit.dart';

class SubcategoriesPage extends StatelessWidget {
  const SubcategoriesPage({Key? key, required this.categoryId})
      : super(key: key);

  final int categoryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubcategoriesCubit(
        categoryRepository: context.read<CategoryRepository>(),
      )..onInit(categoryId: categoryId),
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
          if (state.status == SubcategoriesStatus.failure) {
            SharedFunctions.showSnackbar(
                context, false, 'Ups', state.errorMessage!);
          }
        }
      },
      builder: (context, state) {
        final themeState = context.read<ThemeCubit>().state;
        return Scaffold(
          appBar: AppBar(
            title: _buildTitle(state.category),
          ),
          body: Column(
            children: [
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: state.subcategoriesByCategory.length,
                  itemBuilder: (context, index) {
                    final subcategory = state.subcategoriesByCategory[index];
                    return Card(
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.highlight_remove,
                                color: Theme.of(context).colorScheme.error),
                            onPressed: () {
                              context
                                  .read<SubcategoriesCubit>()
                                  .onSubcategoryDeleted(subcategory.id);
                            },
                          ),
                          Text(
                            subcategory.name,
                            style: TextStyle(
                                color: BudgetTheme.isDarkMode(context)
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          IconButton(
                              onPressed: () => context
                                  .push('/subcategories/edit/${subcategory.id}'
                                      '?categoryId=${state.category!.id}'),
                              icon: Icon(Icons.chevron_right))
                        ],
                      ),
                    );
                  },
                ),
              ),
              ListTile(
                tileColor: BudgetTheme.isDarkMode(context)
                    ? BudgetColors.accentDark
                    : themeState.secondaryColor,
                title: Text(
                  'Add Subcategory',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold),
                ),
                trailing: Icon(Icons.add, color: Colors.white),
                onTap: () => context.push(
                    '/subcategories/new?categoryId=${state.category!.id}'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle(Category? category) {
    final body = 'Subcategories for ${category == null ? '' : category.name}';
    return Text(body);
  }
}
