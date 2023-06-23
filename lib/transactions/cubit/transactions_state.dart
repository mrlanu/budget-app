part of 'transactions_cubit.dart';

enum TransactionsStatus { initial, loading, success, failure }

class TransactionsState extends Equatable {
  final TransactionsStatus status;
  final List<TransactionTile> transactionList;
  final TransactionsViewFilter filter;
  final String? errorMessage;
  final Transaction? lastDeletedTransaction;
  final Transfer? lastDeletedTransfer;

  const TransactionsState({
    this.status = TransactionsStatus.initial,
    this.transactionList = const [],
    required this.filter,
    this.errorMessage,
    this.lastDeletedTransaction,
    this.lastDeletedTransfer,
  });

  List<TransactionTile> get filteredTiles => filter.applyAll(transactionList);

  TransactionsState copyWith({
    TransactionsStatus? status,
    List<TransactionTile>? transactionList,
    TransactionsViewFilter? filter,
    String? errorMessage,
    Transaction? Function()? lastDeletedTransaction,
    Transfer? Function()? lastDeletedTransfer,
  }) {
    return TransactionsState(
        status: status ?? this.status,
        transactionList: transactionList ?? this.transactionList,
        filter: filter ?? this.filter,
        errorMessage: errorMessage ?? this.errorMessage,
        lastDeletedTransaction: lastDeletedTransaction != null
            ? lastDeletedTransaction()
            : this.lastDeletedTransaction,
        lastDeletedTransfer: lastDeletedTransfer != null
            ? lastDeletedTransfer()
            : this.lastDeletedTransfer);
  }

  @override
  List<Object?> get props => [
        status,
        transactionList,
        filter,
        errorMessage,
        lastDeletedTransaction,
        lastDeletedTransfer,
      ];
}
