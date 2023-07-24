import 'package:json_annotation/json_annotation.dart';

part 'year_month_sum.g.dart';

@JsonSerializable()
class YearMonthSum {
  final String date;
  final double expenseSum;
  final double incomeSum;

  YearMonthSum(
      {required this.date, required this.expenseSum, required this.incomeSum});

  factory YearMonthSum.fromJson(Map<String, dynamic> json) =>
      _$YearMonthSumFromJson(json);

  Map<String, dynamic> toJson() => _$YearMonthSumToJson(this);

  @override
  String toString() {
    return 'date: $date exp: $expenseSum inc: $incomeSum';
  }
}
