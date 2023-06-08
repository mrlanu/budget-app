part of 'transactions_cubit.dart';

enum TransactionsStatus { initial, loading, success, failure }

class TransactionsState extends Equatable {
  final TransactionsStatus status;
  final List<Transaction> transactionList;
  final TransactionsFilter filterBy;
  final String filterId;
  final DateTime? filterDate;
  final String? errorMessage;
  final Transaction? lastDeletedTransaction;

  const TransactionsState({
    this.status = TransactionsStatus.initial,
    this.transactionList = const [],
    required this.filterBy,
    required this.filterId,
    required this.filterDate,
    this.errorMessage,
    this.lastDeletedTransaction,
  });

  TransactionsState copyWith({
    TransactionsStatus? status,
    List<Transaction>? transactionList,
    TransactionsFilter? filterBy,
    String? filterId,
    DateTime? filterDate,
    String? errorMessage,
    Transaction? Function()? lastDeletedTransaction,
  }) {
    return TransactionsState(
      status: status ?? this.status,
      transactionList: transactionList ?? this.transactionList,
      filterBy: filterBy ?? this.filterBy,
      filterId: filterId ?? this.filterId,
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
        filterBy,
        filterId,
        filterDate,
        errorMessage,
        lastDeletedTransaction
      ];
}
