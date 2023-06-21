part of 'transactions_cubit.dart';

enum TransactionsStatus { initial, loading, success, failure }

class TransactionsState extends Equatable {
  final TransactionsStatus status;
  final List<TransactionTile> transactionList;
  final TransactionsViewFilter filter;
  final String? errorMessage;
  final Transaction? lastDeletedTransaction;

  const TransactionsState({
    this.status = TransactionsStatus.initial,
    this.transactionList = const [],
    required this.filter,
    this.errorMessage,
    this.lastDeletedTransaction,
  });

  List<TransactionTile> get filteredTiles => filter.applyAll(transactionList);

  TransactionsState copyWith({
    TransactionsStatus? status,
    List<TransactionTile>? transactionList,
    TransactionsViewFilter? filter,
    String? errorMessage,
    Transaction? Function()? lastDeletedTransaction,
  }) {
    return TransactionsState(
      status: status ?? this.status,
      transactionList: transactionList ?? this.transactionList,
      filter: filter ?? this.filter,
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
        errorMessage,
        lastDeletedTransaction
      ];
}
