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
  final List<TransactionTile> transactionTilesList;

  //here should be AccountWithDetails instead of Account
  final List<AccountWithDetails> accounts;
  final List<Category> categories;
  final List<Subcategory> subcategories;
  final DateTime? selectedDate;
  final HomeTab tab;
  final String? errorMessage;
  final TransactionTile? lastDeletedTransaction;

  double get expenses {
    return transactionTilesList
        .where((tr) => tr.type == TransactionType.EXPENSE)
        .fold<double>(
            0, (previousValue, element) => previousValue + element.amount);
  }

  double get incomes {
    return transactionTilesList
        .where((tr) => tr.type == TransactionType.INCOME)
        .fold<double>(
            0, (previousValue, element) => previousValue + element.amount);
  }

  double get accountsTotal {
    return accounts.where((acc) => acc.includeInTotal).fold<double>(
        0.0, (previousValue, element) => previousValue + element.balance);
  }

  List<SummaryTile> get summariesByCategory {
    switch (tab) {
      case HomeTab.expenses:
        final tiles = transactionTilesList
            .where((tr) =>
                tr.type == TransactionType.EXPENSE && tr.toAccount == null)
            .toList();
        return _getSummariesByCategory(tiles);
      case HomeTab.income:
        final tiles = transactionTilesList
            .where((tr) =>
                tr.type == TransactionType.INCOME && tr.toAccount == null)
            .toList();
        return _getSummariesByCategory(tiles);
      case HomeTab.accounts:
        return _getSummariesByAccounts(transactionTiles: transactionTilesList);
    }
  }

  List<SummaryTile> _getSummariesByCategory(
      List<TransactionTile> filteredTiles) {
    List<SummaryTile> summaries = [];
    final groupedTrByCat =
        groupBy(filteredTiles, (TransactionTile tr) => tr.category!);

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
      {required List<TransactionTile> transactionTiles}) {
    List<SummaryTile> summaries = [];
    accounts.forEach((acc) {
      summaries.add(SummaryTile(
          id: acc.id!,
          name: acc.name,
          total: acc.balance,
          comprehensiveTr: transactionTiles
              .where((tr) =>
                  (tr.fromAccount!.id == acc.id &&
                      tr.type != TransactionType.TRANSFER) ||
                  (tr.toAccount?.id == acc.id && tr.title == 'Transfer in') ||
                  (tr.fromAccount?.id == acc.id && tr.title == 'Transfer out'))
              .toList(),
          //here should be AccountWithDetails instead of Account
          iconCodePoint: acc.category.iconCode));
    });
    return summaries;
  }

  const HomeState({
    this.status = HomeStatus.initial,
    this.transactionTilesList = const [],
    this.accounts = const [],
    this.categories = const [],
    this.subcategories = const [],
    this.selectedDate,
    this.tab = HomeTab.expenses,
    this.errorMessage,
    this.lastDeletedTransaction,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<TransactionTile>? transactionTilesList,
    List<AccountWithDetails>? accounts,
    List<Category>? categories,
    List<Subcategory>? subcategories,
    TransactionsViewFilter? filter,
    List<SummaryTile>? summaryList,
    DateTime? selectedDate,
    HomeTab? tab,
    String? errorMessage,
    TransactionTile? Function()? lastDeletedTransaction,
  }) {
    return HomeState(
      status: status ?? this.status,
      transactionTilesList: transactionTilesList ?? this.transactionTilesList,
      accounts: accounts ?? this.accounts,
      categories: categories ?? this.categories,
      subcategories: subcategories ?? this.subcategories,
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
        accounts,
        categories,
        subcategories,
        transactionTilesList,
        selectedDate,
        tab,
        errorMessage,
        lastDeletedTransaction
      ];
}
