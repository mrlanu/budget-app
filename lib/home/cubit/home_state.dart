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
  final List<SummaryBy> summaryList;
  final Map<String, double> sectionSummary;
  final HomeStatus status;
  final HomeTab tab;
  final DateTime? selectedDate;
  final String? errorMessage;

  const HomeState(
      {this.summaryList = const [],
        this.sectionSummary = const {
          'ACCOUNTS': 0.0,
          'EXPENSES': 0.0,
          'INCOME': 0.0
        },
      this.status = HomeStatus.initial,
      this.tab = HomeTab.expenses,
      this.selectedDate,
      this.errorMessage});

  HomeState copyWith({
    List<SummaryBy>? summaryList,
    Map<String, double>? sectionSummary,
    HomeStatus? status,
    Budget? budget,
    DateTime? selectedDate,
    HomeTab? tab,
    String? errorMessage,
  }) {
    return HomeState(
      summaryList:
          summaryList ?? this.summaryList,
      sectionSummary: sectionSummary ?? this.sectionSummary,
      status: status ?? this.status,
      selectedDate: selectedDate ?? this.selectedDate,
      tab: tab ?? this.tab,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [summaryList, sectionSummary, status, tab, selectedDate, errorMessage];
}
