part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, failure }

enum HomeTab {
  expenses(name: 'EXPENSES'),
  income(name: 'INCOME'),
  accounts(name: 'ACCOUNTS');

  final String name;

  const HomeTab({required this.name});
}

class HomeState extends Equatable {
  final HomeStatus status;
  final HomeTab tab;
  final Budget? budget;
  final Map<String, double> sectionSummary;
  final DateTime? selectedDate;
  final String? errorMessage;

  const HomeState(
      {this.status = HomeStatus.initial,
      this.tab = HomeTab.expenses,
        this.budget,
      this.sectionSummary = const {
        'ACCOUNTS': 0.0,
        'EXPENSES': 0.0,
        'INCOME': 0.0
      },
      this.selectedDate,
      this.errorMessage});

  HomeState copyWith({
    HomeStatus? status,
    Budget? budget,
    Map<String, double>? sectionSummary,
    List<CategorySummary>? categorySummaryList,
    DateTime? selectedDate,
    HomeTab? tab,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      budget: budget ?? this.budget,
      sectionSummary: sectionSummary ?? this.sectionSummary,
      selectedDate: selectedDate ?? this.selectedDate,
      tab: tab ?? this.tab,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, tab, budget, sectionSummary, selectedDate, errorMessage];
}
