import 'package:budget_app/budgets/budgets.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../transaction.dart';

part 'transaction.g.dart';

@JsonSerializable()
@Collection(inheritance: false)
class Transaction {
  final String? id;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Id? isarId;
  final String budgetId;
  final DateTime date;
  @enumerated
  final TransactionType type;
  final double amount;
  final String fromAccountId;
  final String? toAccountId;
  final String? description;
  final String? categoryId;
  final String? subcategoryId;

  Transaction({
    this.id,
    this.isarId,
    required this.budgetId,
    required this.date,
    required this.amount,
    required this.type,
    this.description = '',
    this.categoryId,
    this.subcategoryId,
    required this.fromAccountId,
    this.toAccountId,
  });

  List<ComprehensiveTransaction> toTile(Budget budget){
    switch(this.type){
      case TransactionType.EXPENSE || TransactionType.INCOME:
        final cat = budget.getCategoryById(this.categoryId!);
        final subcategory = cat.subcategoryList
            .where((sc) => this.subcategoryId == sc.id)
            .first;
        final acc = budget.getAccountById(this.fromAccountId);
        return [ComprehensiveTransaction(
            id: this.id!,
            budgetId: budgetId,
            type: this.type,
            amount: this.amount,
            title: subcategory.name,
            subtitle: acc.name,
            dateTime: this.date,
            description: this.description!,
            category: cat,
            subcategory: subcategory,
            fromAccount: acc)];
      case TransactionType.TRANSFER:
        final fromAccount = budget.getAccountById(this.fromAccountId);
        final toAccount = budget.getAccountById(this.toAccountId!);
        return [ComprehensiveTransaction(
          id: this.id!,
          budgetId: budgetId,
          type: TransactionType.TRANSFER,
          amount: this.amount,
          title: 'Transfer in',
          subtitle: 'from ${fromAccount.name}',
          dateTime: this.date,
          description: this.description!,
          fromAccount: fromAccount,
          toAccount: toAccount,),
          ComprehensiveTransaction(
              id: this.id!,
              budgetId: budgetId,
              type: TransactionType.TRANSFER,
              amount: this.amount,
              title: 'Transfer out',
              subtitle: 'to ${toAccount.name}',
              dateTime: this.date,
              description: this.description!,
              fromAccount: fromAccount,
              toAccount: toAccount)];
      case _:
        return [];
    }
  }

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
