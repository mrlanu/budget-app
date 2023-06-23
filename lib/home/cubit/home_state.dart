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
  final List<Account> accounts;
  final Map<String, double> sectionsSum;
  final List<SummaryTile> summaryList;
  final HomeStatus status;
  final HomeTab tab;
  final DateTime? selectedDate;
  final String? errorMessage;

  const HomeState({this.transactions = const [],
    this.categories = const [],
    this.accounts = const [],
    this.sectionsSum = const {'incomes': 0.0, 'expenses': 0.0, 'accounts': 0.0},
    this.summaryList = const [],
    this.status = HomeStatus.initial,
    this.tab = HomeTab.expenses,
    this.selectedDate,
    this.errorMessage});

  HomeState copyWith({
    List<Transaction>? transactions,
    List<Category>? categories,
    List<Account>? accounts,
    Map<String, double>? sectionsSum,
    List<SummaryTile>? summaryList,
    HomeStatus? status,
    Budget? budget,
    DateTime? selectedDate,
    HomeTab? tab,
    String? errorMessage,
  }) {
    return HomeState(
      transactions: transactions ?? this.transactions,
      categories: categories ?? this.categories,
      accounts: accounts ?? this.accounts,
      sectionsSum: sectionsSum ?? this.sectionsSum,
      summaryList: summaryList ?? this.summaryList,
      status: status ?? this.status,
      selectedDate: selectedDate ?? this.selectedDate,
      tab: tab ?? this.tab,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [
        transactions,
        categories,
        accounts,
        sectionsSum,
        summaryList,
        status,
        tab,
        selectedDate,
        errorMessage
      ];
}
