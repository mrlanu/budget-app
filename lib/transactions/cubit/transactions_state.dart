part of 'transactions_cubit.dart';

enum TransactionsStatus { initial, loading, success, failure }

class TransactionsState extends Equatable {
  final TransactionsStatus status;
  final List<TransactionTile> transactionList;
  final TransactionsFilter filter;
  final DateTime? filterDate;
  final String? errorMessage;
  final Transaction? lastDeletedTransaction;

  const TransactionsState({
    this.status = TransactionsStatus.initial,
    this.transactionList = const [],
    required this.filter,
    required this.filterDate,
    this.errorMessage,
    this.lastDeletedTransaction,
  });

  TransactionsState copyWith({
    TransactionsStatus? status,
    List<TransactionTile>? transactionList,
    TransactionsFilter? filter,
    String? filterId,
    DateTime? filterDate,
    String? errorMessage,
    Transaction? Function()? lastDeletedTransaction,
  }) {
    return TransactionsState(
      status: status ?? this.status,
      transactionList: transactionList ?? this.transactionList,
      filter: filter ?? this.filter,
      filterDate: filterDate ?? this.filterDate,
      errorMessage: errorMessage ?? this.errorMessage,
      lastDeletedTransaction:
      lastDeletedTransaction != null ? lastDeletedTransaction() : this.lastDeletedTransaction,
    );
  }

  @override
  List<Object?> get props => [
        status,
        transactionList,
        filter,
        filterDate,
        errorMessage,
        lastDeletedTransaction
      ];
}
