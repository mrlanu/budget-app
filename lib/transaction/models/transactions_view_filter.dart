

import '../transaction.dart';

enum TransactionsViewFilterTypes {
  categoryId,
  accountId,
  allExpenses,
  allIncomes,
}

class TransactionsViewFilter {
  final TransactionsViewFilterTypes type;
  final String? filterId;
  const TransactionsViewFilter({required this.type, this.filterId});

  bool apply({required TransactionTile transactionTile}) {
    switch (this.type) {
      case TransactionsViewFilterTypes.allExpenses:
        return transactionTile.type == TransactionType.EXPENSE;
      case TransactionsViewFilterTypes.allIncomes:
        return transactionTile.type == TransactionType.INCOME;
      case TransactionsViewFilterTypes.categoryId:
        return transactionTile.category?.id == filterId!;
      case TransactionsViewFilterTypes.accountId:
        if(transactionTile.type == TransactionType.TRANSFER){
          return (transactionTile.fromAccount == filterId && transactionTile.title == 'Transfer out') ||
              (transactionTile.toAccount == filterId && transactionTile.title == 'Transfer in');
        }else{
          return transactionTile.fromAccount == filterId;
        }
    }
  }

  List<TransactionTile> applyAll(Iterable<TransactionTile> transactionTiles) {
    return transactionTiles.where(
      (trT) => apply(transactionTile: trT),
    ).toList();
  }
}
