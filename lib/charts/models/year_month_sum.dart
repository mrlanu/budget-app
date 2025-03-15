class YearMonthSum {
  final DateTime date;
  final double expenseSum;
  final double incomeSum;

  YearMonthSum(
      {required this.date, required this.expenseSum, required this.incomeSum});

  @override
  String toString() {
    return 'date: $date exp: $expenseSum inc: $incomeSum';
  }
}
