import 'package:qruto_budget/categories/repository/category_repository.dart';
import 'package:qruto_budget/transaction/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/theme/cubit/theme_cubit.dart';
import '../category_edit.dart';

class CategoryEditDialog extends StatelessWidget {
  const CategoryEditDialog({super.key, this.categoryId, required this.type});

  final int? categoryId;
  final TransactionType type;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return CategoryEditBloc(
            categoryRepository: context.read<CategoryRepository>())
          ..add(CategoryEditFormLoaded(categoryId: categoryId, type: type));
      },
      child: CategoryEditForm(),
    );
  }
}

class CategoryEditForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryEditBloc, CategoryEditState>(
      builder: (context, state) {
        final h = MediaQuery.of(context).size.height;
        final colors = context.read<ThemeCubit>().state;
        return Center(
          child: SingleChildScrollView(
            child: Dialog(
              insetPadding: EdgeInsets.all(10),
              child: Container(
                height: h * 0.7,
                width: double.infinity,
                child: state.catStatus == CategoryEditStatus.loading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                state.id == null
                                    ? 'Add ${state.type == TransactionType.EXPENSE ? 'expense' : 'income'} category'
                                    : 'Edit ${state.type == TransactionType.EXPENSE ? 'expense' : 'income'} category',
                                style: Theme.of(context).textTheme.titleLarge),
                            SizedBox(height: 20),
                            TextFormField(
                                initialValue: state.name,
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.notes,
                                    color: colors.secondaryColor,
                                  ),
                                  border: OutlineInputBorder(),
                                  labelText: 'Name',
                                ),
                                onChanged: (name) =>
                                    context.read<CategoryEditBloc>().add(
                                          CategoryNameChanged(name: name),
                                        )),
                            SizedBox(height: 10),
                            Divider(),
                            Expanded(
                                child: CategoriesGrid(
                                    selectedIconCode: state.iconCode,
                                    onSelect: (code) => context
                                        .read<CategoryEditBloc>()
                                        .add(CategoryIconChanged(code: code)))),
                            Divider(),
                            SizedBox(height: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor: colors.secondaryColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 48, vertical: 14),
                              ),
                              onPressed: state.name == null ||
                                  state.name?.length == 0 ||
                                  state.iconCode < 0
                                  ? null
                                  : () => _submit(context),
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 26.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _submit(BuildContext context) {
    context.read<CategoryEditBloc>().add(CategoryFormSubmitted());
    context.pop();
  }
}
