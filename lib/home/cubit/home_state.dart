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
  final List<TransactionWithDetails> transactions;

  //here should be AccountWithDetails instead of Account
  final List<AccountWithDetails> accounts;
  final List<Category> categories;
  final List<Subcategory> subcategories;
  final DateTime? selectedDate;
  final HomeTab tab;
  final String? errorMessage;
  final TransactionWithDetails? lastDeletedTransaction;

  double get expenses {
    return transactions
        .where((tr) => tr.type == TransactionType.EXPENSE)
        .fold<double>(
            0, (previousValue, element) => previousValue + element.amount);
  }

  double get incomes {
    return transactions
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
        final tiles = transactions
            .where((tr) =>
                tr.type == TransactionType.EXPENSE && tr.toAccount == null)
            .map(_toTile)
            .expand((list) => list)
            .toList();
        return _getSummariesByCategory(tiles);
      case HomeTab.income:
        final tiles = transactions
            .where((tr) =>
                tr.type == TransactionType.INCOME && tr.toAccount == null)
            .map(_toTile)
            .expand((list) => list)
            .toList();
        return _getSummariesByCategory(tiles);
      case HomeTab.accounts:
        return _getSummariesByAccounts(transactions: transactions);
    }
  }

  List<TransactionTile> _toTile(TransactionWithDetails transaction) {
    switch (transaction.type) {
      case TransactionType.EXPENSE || TransactionType.INCOME:
        return [
          TransactionTile(
              id: transaction.id,
              type: transaction.type,
              amount: transaction.amount,
              title: transaction.subcategory!.name,
              subtitle: transaction.fromAccount.name,
              dateTime: transaction.date,
              description: transaction.description,
              category: transaction.category,
              subcategory: transaction.subcategory!.name,
              fromAccount: transaction.fromAccount.name)
        ];
      case TransactionType.TRANSFER:
        return [
          TransactionTile(
            id: transaction.id,
            type: TransactionType.TRANSFER,
            amount: transaction.amount,
            title: 'Transfer in',
            subtitle: 'from ${transaction.fromAccount.name}',
            dateTime: transaction.date,
            description: transaction.description,
            fromAccount: transaction.fromAccount.name,
            toAccount: transaction.toAccount!.name,
          ),
          TransactionTile(
              id: transaction.id,
              type: TransactionType.TRANSFER,
              amount: transaction.amount,
              title: 'Transfer out',
              subtitle: 'to ${transaction.toAccount!.name}',
              dateTime: transaction.date,
              description: transaction.description,
              fromAccount: transaction.fromAccount.name,
              toAccount: transaction.toAccount!.name)
        ];
      case _:
        return [];
    }
  }

  List<SummaryTile> _getSummariesByCategory(
      List<TransactionTile> transactions) {
    List<SummaryTile> summaries = [];
    final groupedTrByCat =
        groupBy(transactions, (TransactionTile tr) => tr.category);

    groupedTrByCat.forEach((key, value) {
      final double sum = value.fold<double>(
          0.0, (previousValue, element) => previousValue + element.amount);
      value.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      summaries.add(SummaryTile(
          name: key!.name,
          total: sum,
          transactionTiles: value,
          iconCodePoint: key.iconCode));
    });
    return summaries;
  }

  List<SummaryTile> _getSummariesByAccounts(
      {required List<TransactionWithDetails> transactions}) {
    List<SummaryTile> summaries = [];
    accounts.forEach((acc) {
      final transactionTiles = transactions
          .map(_toTile)
          .expand((list) => list)
          .where((tr) =>
      (tr.fromAccount == acc.name &&
          tr.type != TransactionType.TRANSFER) ||
          (tr.toAccount == acc.name && tr.title == 'Transfer in') ||
          (tr.fromAccount == acc.name && tr.title == 'Transfer out'))
          .toList();
      transactionTiles.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      summaries.add(SummaryTile(
          name: acc.name,
          total: acc.balance,
          transactionTiles: transactionTiles,
          iconCodePoint: acc.category.iconCode));
    });
    return summaries;
  }

  const HomeState({
    this.status = HomeStatus.initial,
    this.transactions = const [],
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
    List<TransactionWithDetails>? transactions,
    List<AccountWithDetails>? accounts,
    List<Category>? categories,
    List<Subcategory>? subcategories,
    List<SummaryTile>? summaryList,
    DateTime? selectedDate,
    HomeTab? tab,
    String? errorMessage,
    TransactionWithDetails? Function()? lastDeletedTransaction,
  }) {
    return HomeState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
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
        transactions,
        selectedDate,
        tab,
        errorMessage,
        lastDeletedTransaction
      ];
}
