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
  final Map<String, double> sectionsSum;
  final HomeStatus status;
  final HomeTab tab;
  final DateTime? selectedDate;
  final String? errorMessage;

  const HomeState(
      {this.sectionsSum = const {
        'incomes': 0.0,
        'expenses': 0.0,
        'accounts': 0.0
      },
      this.status = HomeStatus.initial,
      this.tab = HomeTab.expenses,
      this.selectedDate,
      this.errorMessage});

  HomeState copyWith({
    Map<String, double>? sectionsSum,
    HomeStatus? status,
    DateTime? selectedDate,
    HomeTab? tab,
    String? errorMessage,
  }) {
    return HomeState(
      sectionsSum: sectionsSum ?? this.sectionsSum,
      status: status ?? this.status,
      selectedDate: selectedDate ?? this.selectedDate,
      tab: tab ?? this.tab,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [sectionsSum, status, tab, selectedDate, errorMessage];
}
