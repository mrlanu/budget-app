import 'package:budget_app/categories/repository/category_repository.dart';
import 'package:budget_app/subcategories/subcategory_edit/subcategory_edit.dart';
import 'package:budget_app/utils/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/theme/budget_theme.dart';

class SubcategoryEditDialog extends StatelessWidget {
  const SubcategoryEditDialog(
      {super.key, required this.categoryId, this.subcategoryId});

  final int categoryId;
  final int? subcategoryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubcategoryEditBloc(
          categoryRepository: context.read<CategoryRepository>())
        ..add(SubcategoryEditFormLoaded(
            categoryId: categoryId, subcategoryId: subcategoryId)),
      child: SubcategoryEditForm(),
    );
  }
}

class SubcategoryEditForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.read<ThemeCubit>().state;
    final h = MediaQuery.of(context).size.height;
    return BlocBuilder<SubcategoryEditBloc, SubcategoryEditState>(
      builder: (context, state) {
        final categoryName = state.category?.name ?? '';
        return Dialog(
          child: Container(
            height: h * 0.3,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    overflow: TextOverflow.ellipsis,
                    state.id == null ? 'Subcategory for $categoryName' : 'Edit subcategory',
                    style: Theme.of(context).textTheme.titleLarge),
                  TextFormField(
                      initialValue: state.name,
                      autofocus: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                      ),
                      onChanged: (name) => context
                          .read<SubcategoryEditBloc>()
                          .add(SubcategoryNameChanged(name: name))),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: colors.secondaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48, vertical: 14),
                    ),
                    onPressed: () => _submit(context),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          color: BudgetTheme.isDarkMode(context)
                              ? Colors.black
                              : Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 26.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _submit(BuildContext context) {
    context.read<SubcategoryEditBloc>().add(SubcategoryFormSubmitted());
    context.pop();
  }
}
