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
  final Subcategory? subcategory;

  Transaction({
    required this.id,
    required this.date,
    required this.amount,
    this.type = TransactionType.EXPENSE,
    this.subcategory,
    this.description = '',
  });

  factory Transaction.fromComprehensive(
      {required ComprehensiveTransaction comprehensiveTransaction}) {
    return Transaction(
      id: comprehensiveTransaction.id,
      type: comprehensiveTransaction.type,
      date: comprehensiveTransaction.dateTime,
      amount: comprehensiveTransaction.amount,
      subcategory: comprehensiveTransaction.subcategory,
      description: comprehensiveTransaction.description,
    )
      ..fromAccount.value = comprehensiveTransaction.fromAccount
      ..toAccount.value = comprehensiveTransaction.toAccount
      ..category.value = comprehensiveTransaction.category;
  }

  List<ComprehensiveTransaction> toTile() {
    switch (this.type) {
      case TransactionType.EXPENSE || TransactionType.INCOME:
        return [
          ComprehensiveTransaction(
              type: this.type,
              amount: this.amount,
              title: subcategory!.name,
              subtitle: fromAccount.value!.name,
              dateTime: date,
              description: description!,
              category: category.value,
              subcategory: subcategory,
              fromAccount: fromAccount.value,
              id: id!)
        ];
      case TransactionType.TRANSFER:
        return [
          ComprehensiveTransaction(
            id: id!,
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

  Transaction copyWith({
    int? id,
    DateTime? date,
    TransactionType? type,
    double? amount,
    IsarLink<Account>? fromAccount,
    IsarLink<Account>? toAccount,
    String? description,
    IsarLink<Category>? category,
    Subcategory? subcategory,
  }) {
    return Transaction(
        id: id ?? this.id,
        date: date ?? this.date,
        type: type ?? this.type,
        subcategory: subcategory ?? this.subcategory,
        description: description ?? this.description,
        amount: amount ?? this.amount)
      ..fromAccount.value = fromAccount?.value ?? this.fromAccount.value
      ..toAccount.value = toAccount?.value ?? this.toAccount.value
      ..category.value = category?.value ?? this.category.value;
  }
}
