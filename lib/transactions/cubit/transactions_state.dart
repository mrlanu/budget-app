part of 'transactions_cubit.dart';

enum TransactionsStatus { initial, loading, success, failure }

class TransactionsState extends Equatable {

  final TransactionsStatus status;
  final List<Transaction> transactionList;
  final String lastCategoryId;
  final DateTime? lastDate;
  final String? errorMessage;

  const TransactionsState({
    this.status = TransactionsStatus.initial,
    this.transactionList = const [],
    this.lastDate,
    this.lastCategoryId = '',
    this.errorMessage,
});

  TransactionsState copyWith({
    TransactionsStatus? status,
    List<Transaction>? transactionList,
    String? lastCategoryId,
    DateTime? lastDate,
    String? errorMessage,
  }) {
    return TransactionsState(
      status: status ?? this.status,
      transactionList: transactionList ?? this.transactionList,
      lastCategoryId: lastCategoryId ?? this.lastCategoryId,
      lastDate: lastDate ?? this.lastDate,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, transactionList, lastCategoryId, lastDate, errorMessage];
}

