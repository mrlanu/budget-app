import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../subcategories/models/subcategory.dart';
import '../../../utils/theme/cubit/theme_cubit.dart';
import '../../transaction.dart';

class SubcategoryInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    final category =
        context.select((TransactionBloc bloc) => bloc.state.category);
    final categories =
    context.select((TransactionBloc bloc) => bloc.state.categories);
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
            ? categories.firstWhere((c) => c.id == category.id).subcategoryList
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
            : categories.firstWhere((c) => c.id == category?.id).subcategoryList
                .firstWhere((c) => c.name == subcategory.name),
        decoration: InputDecoration(
          icon: Icon(
            Icons.category_outlined,
            color: themeState.secondaryColor,
          ),
          border: OutlineInputBorder(),
          labelText: 'Subcategory',
          //errorText: errorSnapshot.data == 0 ? Localization.of(context).categoryEmpty : null),
        ));
  }
}
