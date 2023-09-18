import 'package:budget_app/account_edit/bloc/account_edit_bloc.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../budgets/budgets.dart';
import '../../../categories/view/categories_page.dart';

class CategoryInputField extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountEditBloc, AccountEditState>(
      builder: (context, state) {
        return DropdownButtonFormField<Category>(
            icon: GestureDetector(
              child: Icon(Icons.edit_note),
              onTap: () {
                //_openDialog(context);
                Navigator.of(context).push(CategoriesPage.route(
                    transactionType: TransactionType.ACCOUNT));
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
                  .read<AccountEditBloc>()
                  .add(AccountCategoryChanged(category: newValue));
              //setState(() => selectedValue = newValue);
            },
            value: state.categories.contains(state.category) ? state.category : null,
            decoration: InputDecoration(
              icon: Icon(
                Icons.category,
                color: Colors.orangeAccent,
              ),
              border: OutlineInputBorder(),
              labelText: 'Category',
              //errorText: errorSnapshot.data == 0 ? Localization.of(context).categoryEmpty : null),
            ));
      },
    );
  }
}
