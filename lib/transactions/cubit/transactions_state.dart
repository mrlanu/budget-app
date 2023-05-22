part of 'transactions_cubit.dart';

enum TransactionsStatus { initial, loading, success, failure }

class TransactionsState extends Equatable {

  final TransactionsStatus status;
  final List<Transaction> transactionList;
  final String? errorMessage;

  const TransactionsState({
    this.status = TransactionsStatus.initial,
    this.transactionList = const [],
    this.errorMessage,
});

  TransactionsState copyWith({
    TransactionsStatus? status,
    List<Transaction>? transactionList,
    String? errorMessage,
  }) {
    return TransactionsState(
      status: status ?? this.status,
      transactionList: transactionList ?? this.transactionList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, transactionList, errorMessage];
}

