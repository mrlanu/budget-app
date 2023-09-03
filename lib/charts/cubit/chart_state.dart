part of 'chart_cubit.dart';

enum ChartStatus { loading, success, failure }

class ChartState extends Equatable {
  final ChartStatus status;
  final List<YearMonthSum> data;
  final List<Category> categories;
  final Category? category;
  final String categoryType;

  List<String> get titles {
    return data.map((e) => e.date.split('-')[1]).toList();
  }

  List<double> get dataPoints {
    final result = <double>[];
    data.forEach((element) {
      result.add(element.expenseSum);
    });
    return result;
  }

  List<double> get dataPointsGrouped {
    final result = <double>[];
    data.forEach((element) {
      result.add(element.expenseSum);
      result.add(element.incomeSum);
    });
    return result;
  }

  double get maxValue {
    final expMax = data.map((e) => e.expenseSum).reduce(max);
    final incMax = data.map((e) => e.incomeSum).reduce(max);
    return max(expMax, incMax);
  }

  const ChartState(
      {this.status = ChartStatus.loading,
      this.data = const <YearMonthSum>[],
      this.categories = const [],
      this.category,
      this.categoryType = 'Expenses'});

  ChartState copyWith(
      {ChartStatus? status,
      List<YearMonthSum>? data,
      List<Category>? categories,
      Category? category,
      String? categoryType}) {
    return ChartState(
        status: status ?? this.status,
        data: data ?? this.data,
        categories: categories ?? this.categories,
        category: category ?? this.category,
        categoryType: categoryType ?? this.categoryType);
  }

  @override
  List<Object?> get props => [status, data, categories, category, categoryType];
}
