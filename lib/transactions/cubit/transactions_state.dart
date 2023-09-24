part of 'transactions_cubit.dart';

enum TransactionsStatus { initial, loading, success, failure }

class TransactionsState extends Equatable {
  final TransactionsStatus status;
  final List<Transaction> transactions;
  final List<TransactionTile> transactionList;
  final TransactionsViewFilter filter;
  final Map<String, double> sectionsSum;
  final List<SummaryTile> summaryList;
  final DateTime? selectedDate;
  final HomeTab tab;
  final String? errorMessage;
  final Transaction? lastDeletedTransaction;

  const TransactionsState({
    this.transactions = const [],
    this.status = TransactionsStatus.initial,
    this.transactionList = const [],
    required this.filter,
    this.sectionsSum = const {'incomes': 0.0, 'expenses': 0.0, 'accounts': 0.0},
    this.summaryList = const [],
    this.selectedDate,
    this.tab = HomeTab.expenses,
    this.errorMessage,
    this.lastDeletedTransaction,
  });

  List<TransactionTile> get filteredTiles => filter.applyAll(transactionList);

  TransactionsState copyWith({
    List<Transaction>? transactions,
    TransactionsStatus? status,
    List<TransactionTile>? transactionList,
    TransactionsViewFilter? filter,
    Map<String, double>? sectionsSum,
    List<SummaryTile>? summaryList,
    DateTime? selectedDate,
    HomeTab? tab,
    String? errorMessage,
    Transaction? Function()? lastDeletedTransaction,
    Transfer? Function()? lastDeletedTransfer,
  }) {
    return TransactionsState(
      transactions: transactions ?? this.transactions,
      status: status ?? this.status,
      transactionList: transactionList ?? this.transactionList,
      filter: filter ?? this.filter,
      sectionsSum: sectionsSum ?? this.sectionsSum,
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
        transactions,
        status,
        transactionList,
        filter,
        sectionsSum,
        summaryList,
        selectedDate,
        tab,
        errorMessage,
        lastDeletedTransaction,
      ];
}
