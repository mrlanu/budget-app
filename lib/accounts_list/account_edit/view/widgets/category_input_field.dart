import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../database/database.dart';
import '../../../../transaction/models/transaction_type.dart';
import '../../../../utils/theme/cubit/theme_cubit.dart';
import '../../bloc/account_edit_bloc.dart';

class CategoryInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeCubit>().state;
    final categories = context.select((AccountEditBloc bloc) => bloc.state.categories);
    final category =
        context.select((AccountEditBloc bloc) => bloc.state.category);
    return DropdownButtonFormField<Category>(
        icon: GestureDetector(
          child: Icon(Icons.edit_note),
          onTap: () {
            //_openDialog(context);
            context
                .push('/categories?typeIndex=${TransactionType.ACCOUNT.index}');
          },
        ),
        items: categories
            .where((c) => c.type == TransactionType.ACCOUNT,)
            .map((Category category) {
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
