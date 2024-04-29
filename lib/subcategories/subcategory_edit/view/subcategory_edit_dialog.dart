import 'package:budget_app/subcategories/subcategory_edit/subcategory_edit.dart';
import 'package:budget_app/transaction/repository/transactions_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../categories/models/category.dart';
import '../../models/subcategory.dart';

class SubcategoryEditDialog extends StatelessWidget {
  const SubcategoryEditDialog(
      {super.key, required this.category, this.subcategory});

  final Category category;
  final Subcategory? subcategory;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubcategoryEditBloc(
          transactionsRepository: context.read<TransactionsRepository>())
        ..add(SubcategoryEditFormLoaded(
            category: category, subcategory: subcategory)),
      child: SubcategoryEditForm(),
    );
  }
}

class SubcategoryEditForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubcategoryEditBloc, SubcategoryEditState>(
      builder: (context, state) {
        return AlertDialog(
          title:
              Text(state.id == null ? 'Add subcategory' : 'Edit subcategory'),
          content: TextFormField(
            key: UniqueKey(),
            autofocus: true,
            initialValue: state.name,
            onChanged: (name) => context
                .read<SubcategoryEditBloc>()
                .add(SubcategoryNameChanged(name: name)),
            decoration: InputDecoration(hintText: 'Enter name'),
          ),
          actions: [
            TextButton(
              onPressed: () => _submit(context),
              child: Text('SAVE'),
            )
          ],
        );
      },
    );
  }

  void _submit(BuildContext context) {
    context
        .read<SubcategoryEditBloc>()
        .add(SubcategoryFormSubmitted());
    context.pop();
  }
}
