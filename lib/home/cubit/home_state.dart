part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, failure }

enum HomeTab {
  expenses(name: 'EXPENSE'),
  income(name: 'INCOME'),
  accounts(name: 'ACCOUNTS');

  final String name;

  const HomeTab({required this.name});
}

class HomeState extends Equatable {
  final List<Transaction> transactions;
  final List<Category> categories;
  final double expensesSum;
  final double incomesSum;
  final double accountsSum;
  final List<SummaryBy> summaryList;
  final HomeStatus status;
  final HomeTab tab;
  final DateTime? selectedDate;
  final String? errorMessage;

  const HomeState(
      {this.transactions = const [],
      this.categories = const [],
      this.expensesSum = 0,
      this.incomesSum = 0,
      this.accountsSum = 0,
      this.summaryList = const [],
      this.status = HomeStatus.initial,
      this.tab = HomeTab.expenses,
      this.selectedDate,
      this.errorMessage});

  HomeState copyWith({
    List<Transaction>? transactions,
    List<Category>? categories,
    double? expensesSum,
    double? incomesSum,
    double? accountsSum,
    List<SummaryBy>? summaryList,
    HomeStatus? status,
    Budget? budget,
    DateTime? selectedDate,
    HomeTab? tab,
    String? errorMessage,
  }) {
    return HomeState(
      transactions: transactions ?? this.transactions,
      categories: categories ?? this.categories,
      expensesSum: expensesSum ?? this.expensesSum,
      incomesSum: incomesSum ?? this.incomesSum,
      accountsSum: accountsSum ?? this.accountsSum,
      summaryList: summaryList ?? this.summaryList,
      status: status ?? this.status,
      selectedDate: selectedDate ?? this.selectedDate,
      tab: tab ?? this.tab,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        transactions,
        categories,
        expensesSum,
        incomesSum,
        accountsSum,
        summaryList,
        status,
        tab,
        selectedDate,
        errorMessage
      ];
}
