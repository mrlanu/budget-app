import 'package:budget_app/charts/cubit/chart_cubit.dart';
import 'package:budget_app/charts/view/category_table.dart';
import 'package:budget_app/constants/constants.dart';
import 'package:chart/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../categories/models/category.dart';
import '../charts.dart';

class CategoryChartPage extends StatefulWidget {
  const CategoryChartPage({super.key});

  @override
  State<CategoryChartPage> createState() => _CategoryChartPageState();
}

class _CategoryChartPageState extends State<CategoryChartPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChartCubit>().fetchCategoryChart();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartCubit, ChartState>(
      builder: (context, state) => Scaffold(
          appBar: AppBar(
              title: Text(state.category?.name ?? ''),
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  context.pop();
                },
              ),
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
                            child: BlocBuilder<ChartCubit, ChartState>(
                              builder: (context, state) {
                                return BarChart(
                                  dataPoints: state.dataPoints,
                                  labels: state.titles,
                                  isGrouped: false,
                                  firstColor: state.categoryType == 'Expenses'
                                      ? Colors.red
                                      : Colors.green,
                                );
                              },
                            ),
                          ),
                        ),
                        CategoryInput(),
                        Expanded(child: CategoryTable())
                      ],
                    ))),
    );
  }
}

class TrendChartDesktopView extends StatelessWidget {
  const TrendChartDesktopView({super.key});

  @override
  Widget build(BuildContext context) {
    return TrendChartDesktopViewBody();
  }
}

class TrendChartDesktopViewBody extends StatelessWidget {
  const TrendChartDesktopViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartCubit, ChartState>(
      builder: (context, state) {
        return Center(
            child: state.status == ChartStatus.loading
                ? CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<ChartCubit, ChartState>(
                        builder: (context, state) {
                          return Container(
                            width: w * 0.35,
                            height: h * 0.55,
                            child: BarChart(
                              dataPoints: state.dataPointsGrouped,
                              labels: state.titles,
                              isGrouped: true,
                            ),
                          );
                        },
                      ),
                      SizedBox(width: w * 0.01),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Container(
                            width: w * 0.35,
                            height: h * 0.6,
                            child: TrendTable()),
                      )
                    ],
                  ));
      },
    );
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
