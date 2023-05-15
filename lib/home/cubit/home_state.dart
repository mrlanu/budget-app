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
  final SectionCategorySummary? sectionCategorySummary;
  final HomeStatus status;
  final HomeTab tab;
  final Budget? budget;
  final DateTime? selectedDate;
  final String? errorMessage;

  const HomeState(
      {this.sectionCategorySummary,
        this.status = HomeStatus.initial,
      this.tab = HomeTab.expenses,
        this.budget,
      this.selectedDate,
      this.errorMessage});

  HomeState copyWith({
    SectionCategorySummary? sectionCategorySummary,
    HomeStatus? status,
    Budget? budget,
    List<CategorySummary>? categorySummaryList,
    DateTime? selectedDate,
    HomeTab? tab,
    String? errorMessage,
  }) {
    return HomeState(
      sectionCategorySummary: sectionCategorySummary ?? this.sectionCategorySummary,
      status: status ?? this.status,
      budget: budget ?? this.budget,
      selectedDate: selectedDate ?? this.selectedDate,
      tab: tab ?? this.tab,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [sectionCategorySummary, status, tab, budget, selectedDate, errorMessage];
}
