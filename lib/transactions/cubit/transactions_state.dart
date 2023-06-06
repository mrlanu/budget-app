part of 'transactions_cubit.dart';

enum TransactionsStatus { initial, loading, success, failure }

class TransactionsState extends Equatable {

  final TransactionsStatus status;
  final List<Transaction> transactionList;
  final String lastFilterId;
  final DateTime? lastDate;
  final String? errorMessage;

  const TransactionsState({
    this.status = TransactionsStatus.initial,
    this.transactionList = const [],
    this.lastDate,
    this.lastFilterId = '',
    this.errorMessage,
});

  TransactionsState copyWith({
    TransactionsStatus? status,
    List<Transaction>? transactionList,
    String? lastFilterId,
    DateTime? lastDate,
    String? errorMessage,
  }) {
    return TransactionsState(
      status: status ?? this.status,
      transactionList: transactionList ?? this.transactionList,
      lastFilterId: lastFilterId ?? this.lastFilterId,
      lastDate: lastDate ?? this.lastDate,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, transactionList, lastFilterId, lastDate, errorMessage];
}

