import 'package:budget_app/accounts_list/models/account.dart';
import 'package:budget_app/categories/models/category.dart';
import 'package:budget_app/subcategories/models/models.dart';
import 'package:budget_app/transaction/models/models.dart';
import 'package:isar/isar.dart';

import '../transaction.dart';

part 'transaction.g.dart';

@Collection(inheritance: false)
class Transaction {
  final Id? id;
  final DateTime date;
  @enumerated
  final TransactionType type;
  final double amount;
  final fromAccount = IsarLink<Account>();
  final toAccount = IsarLink<Account>();
  final String? description;
  final category = IsarLink<Category>();
  final subcategory = IsarLink<Subcategory>();

  Transaction({
    required this.id,
    required this.date,
    required this.amount,
    this.type = TransactionType.EXPENSE,
    this.description = '',
  });

  factory Transaction.fromComprehensive(
      {Id? id,
      required TransactionType type,
      DateTime? dateTime,
      double? amount,
      Account? fromAcc,
      Account? toAcc,
      Category? category,
      Subcategory? subcategory,
      String? description}) {
    return Transaction(
      id: null,
      type: type,
      date: dateTime ?? DateTime.now(),
      amount: amount ?? 0,
      description: description,
    )
      ..fromAccount.value = fromAcc
      ..toAccount.value = toAcc
      ..category.value = category
      ..subcategory.value = subcategory;
  }

  List<ComprehensiveTransaction> toTile() {
    switch (this.type) {
      case TransactionType.EXPENSE || TransactionType.INCOME:
        return [
          ComprehensiveTransaction(
              type: this.type,
              amount: this.amount,
              title: subcategory.value!.name,
              subtitle: fromAccount.value!.name,
              dateTime: date,
              description: description!,
              category: category.value,
              subcategory: subcategory.value,
              fromAccount: fromAccount.value,
              id: id!.sign)
        ];
      case TransactionType.TRANSFER:
        return [
          ComprehensiveTransaction(
            id: id!.sign,
            type: TransactionType.TRANSFER,
            amount: this.amount,
            title: 'Transfer in',
            subtitle: 'from ${fromAccount.value!.name}',
            dateTime: date,
            description: description!,
            fromAccount: fromAccount.value,
            toAccount: toAccount.value,
          ),
          ComprehensiveTransaction(
              id: id!.sign,
              type: TransactionType.TRANSFER,
              amount: amount,
              title: 'Transfer out',
              subtitle: 'to ${toAccount.value!.name}',
              dateTime: date,
              description: description!,
              fromAccount: fromAccount.value,
              toAccount: toAccount.value)
        ];
      case _:
        return [];
    }
  }
}
