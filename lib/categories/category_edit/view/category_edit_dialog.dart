import 'package:budget_app/home/cubit/home_cubit.dart';
import 'package:budget_app/transaction/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../budgets/repository/budget_repository.dart';
import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../models/category.dart';
import '../category_edit.dart';

class CategoryEditDialog extends StatelessWidget {
  const CategoryEditDialog({super.key, this.category, required this.type});

  final Category? category;
  final TransactionType type;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CategoryEditBloc(budgetRepository: context.read<BudgetRepository>())
            ..add(CategoryBudgetChanged(
                budget: context.read<HomeCubit>().state.budget))
            ..add(CategoryEditFormLoaded(category: category, type: type)),
      child: CategoryEditForm(),
    );
  }
}

class CategoryEditForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryEditBloc, CategoryEditState>(
      builder: (context, state) {
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
                                    : 'Edit ${state.type == TransactionType.EXPENSE ? 'expense' : 'income'}category',
                                style: Theme.of(context).textTheme.titleLarge),
                            SizedBox(height: 20),
                            TextFormField(
                                initialValue: state.name,
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.notes,
                                    color: Colors.orangeAccent,
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
                            TextButton(
                              onPressed: state.name == null ||
                                      state.name?.length == 0 ||
                                      state.iconCode < 0
                                  ? null
                                  : () => _submit(context),
                              child: Text('SAVE',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: state.name == null ||
                                              state.name?.length == 0 ||
                                              state.iconCode < 0
                                          ? Colors.grey
                                          : BudgetColors.accent)),
                            )
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
