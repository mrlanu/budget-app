import 'package:equatable/equatable.dart';

class YearMonthSum extends Equatable {
  final DateTime date;
  final double expenseSum;
  final double incomeSum;

  YearMonthSum(
      {required this.date, required this.expenseSum, required this.incomeSum});

  @override
  String toString() {
    return 'date: $date exp: $expenseSum inc: $incomeSum';
  }

  @override
  List<Object?> get props => [
    date, expenseSum, incomeSum
  ];
}
