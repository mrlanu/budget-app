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
  final List<Account> accounts;
  final List<SummaryTile> summaryList;
  final DateTime? selectedDate;
  final HomeTab tab;
  final String? errorMessage;
  final ITransaction? lastDeletedTransaction;

  double get expenses {
    return transactions
        .where((tr) => tr.isTransaction())
        .map((tr) => tr as Transaction)
        .where((tr) => tr.type == TransactionType.EXPENSE)
        .fold<double>(
            0, (previousValue, element) => previousValue + element.amount!);
  }

  double get incomes {
    return transactions
        .where((tr) => tr.isTransaction())
        .map((tr) => tr as Transaction)
        .where((tr) => tr.type == TransactionType.INCOME)
        .fold<double>(
            0, (previousValue, element) => previousValue + element.amount!);
  }

  double get accountsTotal {
    return accounts.where((acc) => acc.includeInTotal).fold<double>(
        0.0, (previousValue, element) => previousValue + element.balance);
  }

  const HomeState({
    this.status = HomeStatus.initial,
    this.transactionTiles = const [],
    this.transactions = const [],
    this.accounts = const [],
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
    List<Account>? accounts,
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
      accounts: accounts ?? this.accounts,
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
        transactionTiles,
        accounts,
        selectedDate,
        tab,
        errorMessage,
        lastDeletedTransaction
      ];
}
