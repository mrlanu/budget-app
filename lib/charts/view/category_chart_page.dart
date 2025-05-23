import 'package:qruto_budget/categories/repository/category_repository.dart';
import 'package:qruto_budget/charts/cubit/chart_cubit.dart';
import 'package:qruto_budget/charts/repository/chart_repository.dart';
import 'package:qruto_budget/charts/view/category_table.dart';
import 'package:chart/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../database/database.dart';
import '../charts.dart';

class CategoryChartPage extends StatelessWidget {
  const CategoryChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ChartCubit(
            chartRepository: context.read<ChartRepository>(),
            categoryRepository: context.read<CategoryRepository>())
          ..fetchCategoryChart(),
        child: BlocBuilder<ChartCubit, ChartState>(
            builder: (context, state) => Scaffold(
                appBar: AppBar(
                    title: Text(state.category?.name ?? '',
                        style: TextStyle(fontSize: 30.sp)),
                    actions: [CategoryTypeSelectButton()]),
                body: Center(
                    child: state.status == ChartStatus.loading
                        ? CircularProgressIndicator()
                        : Column(
                            children: [
                              AspectRatio(
                                aspectRatio: 1.3 / 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 30, horizontal: 8),
                                  child: BarChart(
                                    dataPoints: state.dataPoints,
                                    labels: state.titles,
                                    isGrouped: false,
                                    firstColor: state.categoryType == 'Expenses'
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                              ),
                              CategoryInput(),
                              SubcategoryInput(),
                              IncludeCurrentMonthSwitch(),
                              Expanded(child: CategoryTable())
                            ],
                          )))));
  }
}

class CategoryInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartCubit, ChartState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<Category>(
              items: state.categories.map((Category category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (newValue) {
                context.read<ChartCubit>().changeCategory(category: newValue!);
                //setState(() => selectedValue = newValue);
              },
              value: state.categories.contains(state.category)
                  ? state.category
                  : null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Category',
                //errorText: errorSnapshot.data == 0 ? Localization.of(context).categoryEmpty : null),
              )),
        );
      },
    );
  }
}

class SubcategoryInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartCubit, ChartState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<Subcategory>(
              items: state.subcategories.map((Subcategory category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (newValue) {
                context.read<ChartCubit>().fetchSubcategoryChart(newValue!);
                //setState(() => selectedValue = newValue);
              },
              value: state.subcategory,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Subcategory',
                //errorText: errorSnapshot.data == 0 ? Localization.of(context).categoryEmpty : null),
              )),
        );
      },
    );
  }
}
