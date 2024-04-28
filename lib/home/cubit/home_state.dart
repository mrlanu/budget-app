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
  final HomeStatus status;
  final List<ComprehensiveTransaction> transactionList;
  final Budget budget;
  final DateTime? selectedDate;
  final HomeTab tab;
  final String? errorMessage;
  final ComprehensiveTransaction? lastDeletedTransaction;

  double get expenses {
    return transactionList
        .where((tr) => tr.type == TransactionType.EXPENSE)
        .fold<double>(
            0, (previousValue, element) => previousValue + element.amount);
  }

  double get incomes {
    return transactionList
        .where((tr) => tr.type == TransactionType.INCOME)
        .fold<double>(
            0, (previousValue, element) => previousValue + element.amount);
  }

  double get accountsTotal {
    return budget.accountList.where((acc) => acc.includeInTotal).fold<double>(
        0.0, (previousValue, element) => previousValue + element.balance);
  }

  List<SummaryTile> get summariesByCategory {
    switch (tab) {
      case HomeTab.expenses:
        final tiles = transactionList
            .where((tr) =>
                tr.type == TransactionType.EXPENSE && tr.toAccount == null)
            .toList();
        return _getSummariesByCategory(tiles);
      case HomeTab.income:
        final tiles = transactionList
            .where((tr) =>
                tr.type == TransactionType.INCOME && tr.toAccount == null)
            .toList();
        return _getSummariesByCategory(tiles);
      case HomeTab.accounts:
        return _getSummariesByAccounts(transactionTiles: transactionList);
    }
  }

  List<SummaryTile> _getSummariesByCategory(
      List<ComprehensiveTransaction> filteredTiles) {
    List<SummaryTile> summaries = [];
    final groupedTrByCat =
        groupBy(filteredTiles, (ComprehensiveTransaction tr) => tr.category!);

    groupedTrByCat.forEach((key, value) {
      final double sum = value.fold<double>(
          0.0, (previousValue, element) => previousValue + element.amount);

      summaries.add(SummaryTile(
          id: key.id,
          name: key.name,
          total: sum,
          comprehensiveTr: value,
          iconCodePoint: key.iconCode));
    });
    return summaries;
  }

  List<SummaryTile> _getSummariesByAccounts(
      {required List<ComprehensiveTransaction> transactionTiles}) {
    List<SummaryTile> summaries = [];
    budget.accountList.forEach((acc) {
      summaries.add(SummaryTile(
          id: acc.id,
          name: acc.name,
          total: acc.balance,
          comprehensiveTr: transactionTiles
              .where((tr) =>
                  (tr.fromAccount!.id == acc.id &&
                      tr.type != TransactionType.TRANSFER) ||
                  (tr.toAccount?.id == acc.id && tr.title == 'Transfer in') ||
                  (tr.fromAccount?.id == acc.id && tr.title == 'Transfer out'))
              .toList(),
          iconCodePoint: budget.getCategoryById(acc.category).iconCode));
    });
    return summaries;
  }

  const HomeState({
    this.status = HomeStatus.initial,
    this.transactionList = const [],
    this.budget = const Budget(),
    this.selectedDate,
    this.tab = HomeTab.expenses,
    this.errorMessage,
    this.lastDeletedTransaction,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<ComprehensiveTransaction>? transactionList,
    Budget? budget,
    TransactionsViewFilter? filter,
    List<SummaryTile>? summaryList,
    DateTime? selectedDate,
    HomeTab? tab,
    String? errorMessage,
    ComprehensiveTransaction? Function()? lastDeletedTransaction,
  }) {
    return HomeState(
      status: status ?? this.status,
      transactionList: transactionList ?? this.transactionList,
      budget: budget ?? this.budget,
      selectedDate: selectedDate ?? this.selectedDate,
      tab: tab ?? this.tab,
      errorMessage: errorMessage ?? this.errorMessage,
      lastDeletedTransaction: lastDeletedTransaction != null
          ? lastDeletedTransaction()
          : this.lastDeletedTransaction,
    );
  }

  @override
  List<Object?> get props => [
        status,
        budget,
        transactionList,
        selectedDate,
        tab,
        errorMessage,
        lastDeletedTransaction
      ];
}
