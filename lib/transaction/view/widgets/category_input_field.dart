import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../budgets/budgets.dart';
import '../../../constants/colors.dart';
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
                context.push(
                    '/categories?typeIndex=${state.transactionType.index}');
              },
            ),
            items: state.budget.categoryList
                .where((cat) => cat.type == state.transactionType)
                .map((Category category) {
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
            value: state.budget.categoryList.contains(state.category)
                ? state.category
                : null,
            decoration: InputDecoration(
              icon: Icon(
                Icons.category,
                color: BudgetColors.accent,
              ),
              border: OutlineInputBorder(),
              labelText: 'Category',
              //errorText: errorSnapshot.data == 0 ? Localization.of(context).categoryEmpty : null),
            ));
      },
    );
  }
}
