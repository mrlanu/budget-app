part of 'transactions_cubit.dart';

enum TransactionsStatus { initial, loading, success, failure }

class TransactionsState extends Equatable {
  final TransactionsStatus status;
  final List<Transaction> transactionList;
  final String lastFilterId;
  final DateTime? lastDate;
  final String? errorMessage;
  final Transaction? lastDeletedTransaction;

  const TransactionsState({
    this.status = TransactionsStatus.initial,
    this.transactionList = const [],
    this.lastDate,
    this.lastFilterId = '',
    this.errorMessage,
    this.lastDeletedTransaction,
  });

  TransactionsState copyWith({
    TransactionsStatus? status,
    List<Transaction>? transactionList,
    String? lastFilterId,
    DateTime? lastDate,
    String? errorMessage,
    Transaction? lastDeletedTransaction,
  }) {
    return TransactionsState(
      status: status ?? this.status,
      transactionList: transactionList ?? this.transactionList,
      lastFilterId: lastFilterId ?? this.lastFilterId,
      lastDate: lastDate ?? this.lastDate,
      errorMessage: errorMessage ?? this.errorMessage,
      lastDeletedTransaction:
          lastDeletedTransaction ?? this.lastDeletedTransaction,
    );
  }

  @override
  List<Object?> get props => [
        status,
        transactionList,
        lastFilterId,
        lastDate,
        errorMessage,
        lastDeletedTransaction
      ];
}
