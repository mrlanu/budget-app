import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../categories/models/category.dart';
import '../../../utils/theme/cubit/theme_cubit.dart';
import '../../transaction.dart';

class CategoryInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    final categories = context.select((TransactionBloc bloc) => bloc.state.categories);
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
        items: categories
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
            : categories.firstWhere((c) => c.id == category.id),
        decoration: InputDecoration(
          icon: Icon(
            Icons.category,
            color: themeState.secondaryColor,
          ),
          border: OutlineInputBorder(),
          labelText: 'Category',
          //errorText: errorSnapshot.data == 0 ? Localization.of(context).categoryEmpty : null),
        ));
  }
}
