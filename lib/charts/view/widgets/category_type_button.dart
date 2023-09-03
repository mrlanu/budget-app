import 'package:budget_app/charts/cubit/chart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryTypeSelectButton extends StatelessWidget {
  const CategoryTypeSelectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartCubit, ChartState>(
      builder: (context, state) {
        return PopupMenuButton<String>(
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          initialValue: state.categoryType,
          tooltip: 'Choose type',
          onSelected: (type) {
            context.read<ChartCubit>().changeCategoryType(categoryType: type);
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: 'Expenses',
                child: Text('Expenses'),
              ),
              PopupMenuItem(
                value: 'Income',
                child: Text('Income'),
              ),
            ];
          },
          icon: const Icon(Icons.filter_2),
        );
      },
    );
  }
}
