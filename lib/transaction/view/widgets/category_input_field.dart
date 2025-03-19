import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../database/database.dart';
import '../../../utils/theme/cubit/theme_cubit.dart';
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
                context.push(
                    '/categories?typeIndex=${state.transactionType.index}');
              },
            ),
            items: state.categories
                .where((cat) => cat.type == state.transactionType)
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
            value: state.category == null
                ? null
                : state.categories
                    .firstWhere((c) => c.id == state.category!.id),
            decoration: InputDecoration(
              icon: Icon(
                Icons.category,
                color: context.read<ThemeCubit>().state.secondaryColor,
              ),
              border: OutlineInputBorder(),
              labelText: 'Category',
              //errorText: errorSnapshot.data == 0 ? Localization.of(context).categoryEmpty : null),
            ));
      },
    );
  }
}
