part of 'transactions_cubit.dart';

enum TransactionsStatus { initial, loading, success, failure }

class TransactionsState extends Equatable {
  final TransactionsStatus status;
  final List<TransactionTile> transactionTiles;
  final List<ITransaction> transactions;
  final List<SummaryTile> summaryList;
  final DateTime? selectedDate;
  final HomeTab tab;
  final String? errorMessage;
  final ITransaction? lastDeletedTransaction;

  const TransactionsState({
    this.status = TransactionsStatus.initial,
    this.transactionTiles = const [],
    this.transactions = const [],
    this.summaryList = const [],
    this.selectedDate,
    this.tab = HomeTab.expenses,
    this.errorMessage,
    this.lastDeletedTransaction,
  });

  TransactionsState copyWith({
    TransactionsStatus? status,
    List<TransactionTile>? transactionTiles,
    List<ITransaction>? transactions,
    TransactionsViewFilter? filter,
    List<SummaryTile>? summaryList,
    DateTime? selectedDate,
    HomeTab? tab,
    String? errorMessage,
    ITransaction? Function()? lastDeletedTransaction,
  }) {
    return TransactionsState(
      status: status ?? this.status,
      transactionTiles: transactionTiles ?? this.transactionTiles,
      transactions: transactions ?? this.transactions,
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
        selectedDate,
        tab,
        errorMessage,
    lastDeletedTransaction
      ];
}
