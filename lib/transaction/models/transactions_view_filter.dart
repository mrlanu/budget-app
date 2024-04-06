

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

  bool apply({required ComprehensiveTransaction transactionTile}) {
    switch (this.type) {
      case TransactionsViewFilterTypes.allExpenses:
        return transactionTile.type == TransactionType.EXPENSE;
      case TransactionsViewFilterTypes.allIncomes:
        return transactionTile.type == TransactionType.INCOME;
      case TransactionsViewFilterTypes.categoryId:
        return transactionTile.category?.id == filterId!;
      case TransactionsViewFilterTypes.accountId:
        if(transactionTile.type == TransactionType.TRANSFER){
          return (transactionTile.fromAccount!.id == filterId && transactionTile.title == 'Transfer out') ||
              (transactionTile.toAccount?.id == filterId && transactionTile.title == 'Transfer in');
        }else{
          return transactionTile.fromAccount!.id == filterId;
        }
    }
  }

  List<ComprehensiveTransaction> applyAll(Iterable<ComprehensiveTransaction> transactionTiles) {
    return transactionTiles.where(
      (trT) => apply(transactionTile: trT),
    ).toList();
  }
}
