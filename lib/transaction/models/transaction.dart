import 'package:budget_app/budgets/budgets.dart';
import 'package:budget_app/shared/models/transaction_interface.dart';
import 'package:json_annotation/json_annotation.dart';

import '../transaction.dart';

part 'transaction.g.dart';

@JsonSerializable()
class Transaction implements ITransaction{
  final String? id;
  final String? budgetId;
  final DateTime? date;
  final TransactionType? type;
  final String? description;
  final double? amount;
  final String? categoryId;
  final String? subcategoryId;
  final String? accountId;

  Transaction(
      {this.id,
        this.budgetId,
        this.date,
        this.type,
        this.description = '',
        this.amount,
        this.categoryId,
        this.subcategoryId,
        this.accountId});

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  TransactionTile toTile(
      {required Category category, required Account account, required Subcategory subcategory}) {
    return TransactionTile(
        id: this.id!,
        type: this.type!,
        amount: this.amount!,
        title: subcategory.name,
        subtitle: account.name,
        dateTime: this.date!,
        description: this.description!,
        category: category,
        subcategory: subcategory,
        fromAccount: account);
  }

  @override
  String toString() {
    return 'Transaction {id: $id, date: $date, type: $type, description: $description, amount: $amount, categoryId: $categoryId, sub: $subcategoryId, acc: $accountId';
  }

  @override
  bool isTransaction() => true;

  @override
  String get getId => id!;
}
