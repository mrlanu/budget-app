import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../budgets/budgets.dart';
import '../../../constants/colors.dart';
import '../../transaction.dart';

class SubcategoryInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final budget = context.select((TransactionBloc bloc) => bloc.state.budget);
    final category =
        context.select((TransactionBloc bloc) => bloc.state.category);
    final subcategory =
        context.select((TransactionBloc bloc) => bloc.state.subcategory);
    return DropdownButtonFormField<Subcategory>(
        icon: GestureDetector(
          child: Icon(
            Icons.edit_note,
            color:
                category != null ? Colors.black.withOpacity(0.6) : Colors.grey,
          ),
          onTap: category != null
              ? () => context.push('/subcategories?categoryId=${category.id}')
              : null,
        ),
        items: category != null
            ? budget
                .getCategoryById(category.id)
                .subcategoryList
                .map((Subcategory subcategory) {
                return DropdownMenuItem(
                  value: subcategory,
                  child: Text(subcategory.name),
                );
              }).toList()
            : [],
        onChanged: (newValue) {
          context
              .read<TransactionBloc>()
              .add(TransactionSubcategoryChanged(subcategory: newValue));
          //setState(() => selectedValue = newValue);
        },
        value: subcategory == null
            ? null
            : budget
                .getCategoryById(category!.id)
                .subcategoryList
                .firstWhere((c) => c.id == subcategory.id),
        decoration: InputDecoration(
          icon: Icon(
            Icons.category_outlined,
            color: BudgetColors.accent,
          ),
          border: OutlineInputBorder(),
          labelText: 'Subcategory',
          //errorText: errorSnapshot.data == 0 ? Localization.of(context).categoryEmpty : null),
        ));
  }
}
