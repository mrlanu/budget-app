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
  final Map<String, double> sectionSummary;
  final List<CategorySummary> categorySummaryList;
  final String? errorMessage;

  const HomeState(
      {this.status = HomeStatus.initial,
      this.tab = HomeTab.expenses,
      this.sectionSummary = const {
        'ACCOUNTS': 0.0,
        'EXPENSES': 0.0,
        'INCOME': 0.0
      },
      this.categorySummaryList = const [],
      this.errorMessage});

  HomeState copyWith({
    HomeStatus? status,
    Map<String, double>? sectionSummary,
    List<CategorySummary>? categorySummaryList,
    HomeTab? tab,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      sectionSummary: sectionSummary ?? this.sectionSummary,
      categorySummaryList: categorySummaryList ?? this.categorySummaryList,
      tab: tab ?? this.tab,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, tab, sectionSummary, categorySummaryList, errorMessage];
}
