import 'package:budget_app/accounts/models/account.dart';
import 'package:budget_app/categories/models/category.dart';
import 'package:budget_app/shared/models/subcategory.dart';
import 'package:budget_app/transactions/models/transaction_tile.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

@JsonSerializable()
class Transaction {
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
}
