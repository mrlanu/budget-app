import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../database/database.dart';
import '../../../utils/theme/budget_theme.dart';
import '../../../utils/theme/cubit/theme_cubit.dart';
import '../../transaction.dart';

class SubcategoryInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        final colors = context.read<ThemeCubit>().state;
        return DropdownButtonFormField<Subcategory>(
            icon: GestureDetector(
              child: Icon(
                Icons.edit_note,
                color: state.category != null
                    ? Colors.black.withValues(alpha: 0.6)
                    : Colors.grey,
              ),
              onTap: state.category != null
                  ? () => context
                      .push('/subcategories?categoryId=${state.category!.id}')
                  : null,
            ),
            items: state.category != null
                ? state.subcategories
                    .where(
                    (sc) => sc.categoryId == state.category!.id,
                  )
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
            value: state.subcategory,
            decoration: InputDecoration(
              icon: Icon(
                Icons.category_outlined,
                color: BudgetTheme.isDarkMode(context)
                    ? Colors.white
                    : colors.primaryColor[900],
              ),
              border: OutlineInputBorder(),
              labelText: 'Subcategory',
              //errorText: errorSnapshot.data == 0 ? Localization.of(context).categoryEmpty : null),
            ));
      },
    );
  }
}
