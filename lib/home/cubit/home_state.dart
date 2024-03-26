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
  final List<TransactionTile> transactionTiles;
  final List<ITransaction> transactions;
  final Budget budget;
  final List<SummaryTile> summaryList;
  final DateTime? selectedDate;
  final HomeTab tab;
  final String? errorMessage;
  final ITransaction? lastDeletedTransaction;

  double get expenses {
    return transactionTiles
        .where((tr) => tr.type == TransactionType.EXPENSE)
        .fold<double>(
            0, (previousValue, element) => previousValue + element.amount);
  }

  double get incomes {
    return transactionTiles
        .where((tr) => tr.type == TransactionType.INCOME)
        .fold<double>(
            0, (previousValue, element) => previousValue + element.amount!);
  }

  double get accountsTotal {
    return budget.accountList.where((acc) => acc.includeInTotal).fold<double>(
        0.0, (previousValue, element) => previousValue + element.balance);
  }

  const HomeState({
    this.status = HomeStatus.initial,
    this.transactionTiles = const [],
    this.transactions = const [],
    this.budget = const Budget(),
    this.summaryList = const [],
    this.selectedDate,
    this.tab = HomeTab.expenses,
    this.errorMessage,
    this.lastDeletedTransaction,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<TransactionTile>? transactionTiles,
    List<ITransaction>? transactions,
    Budget? budget,
    TransactionsViewFilter? filter,
    List<SummaryTile>? summaryList,
    DateTime? selectedDate,
    HomeTab? tab,
    String? errorMessage,
    ITransaction? Function()? lastDeletedTransaction,
  }) {
    return HomeState(
      status: status ?? this.status,
      transactionTiles: transactionTiles ?? this.transactionTiles,
      transactions: transactions ?? this.transactions,
      budget: budget ?? this.budget,
      summaryList: summaryList ?? this.summaryList,
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
        summaryList,
        budget,
        selectedDate,
        tab,
        errorMessage,
        lastDeletedTransaction
      ];
}
