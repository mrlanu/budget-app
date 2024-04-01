import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../budgets/budgets.dart';
import '../../../constants/colors.dart';
import '../../transaction.dart';

class CategoryInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final budget = context.select((TransactionBloc bloc) => bloc.state.budget);
    final transactionType =
        context.select((TransactionBloc bloc) => bloc.state.transactionType);
    final category =
        context.select((TransactionBloc bloc) => bloc.state.category);
    return DropdownButtonFormField<Category>(
        icon: GestureDetector(
          child: Icon(Icons.edit_note),
          onTap: () {
            context.push('/categories?typeIndex=${transactionType.index}');
          },
        ),
        items: budget.categoryList
            .where((cat) => cat.type == transactionType)
            .map((Category cat) {
          return DropdownMenuItem(
            value: cat,
            child: Text(cat.name),
          );
        }).toList(),
        onChanged: (newValue) {
          context
              .read<TransactionBloc>()
              .add(TransactionCategoryChanged(category: newValue));
        },
        value: category == null
            ? null
            : budget.categoryList.firstWhere((c) => c.id == category.id),
        decoration: InputDecoration(
          icon: Icon(
            Icons.category,
            color: BudgetColors.accent,
          ),
          border: OutlineInputBorder(),
          labelText: 'Category',
          //errorText: errorSnapshot.data == 0 ? Localization.of(context).categoryEmpty : null),
        ));
  }
}
