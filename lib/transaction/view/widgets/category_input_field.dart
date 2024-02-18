import 'package:budget_app/categories/view/categories_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../budgets/budgets.dart';
import '../../transaction.dart';

class CategoryInput extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return DropdownButtonFormField<Category>(
            icon: GestureDetector(
              child: Icon(Icons.edit_note),
              onTap: () {
                //_openDialog(context);
                Navigator.of(context).push(CategoriesPage.route(
                    transactionType: state.transactionType));
              },
            ),
            items: state.categories.map((Category category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category.name),
              );
            }).toList(),
            onChanged: (newValue) {
              context
                  .read<TransactionBloc>()
                  .add(TransactionCategoryChanged(category: newValue));
              //setState(() => selectedValue = newValue);
            },
            value: state.categories.contains(state.category) ? state.category : null,
            decoration: InputDecoration(
              icon: Icon(
                Icons.category,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              border: OutlineInputBorder(),
              labelText: 'Category',
              //errorText: errorSnapshot.data == 0 ? Localization.of(context).categoryEmpty : null),
            ));
      },
    );
  }
}
