import 'package:budget_app/transactions/models/transaction_tile.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:budget_app/transfer/models/models.dart';
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
  final String? categoryName;
  final String? subcategoryId;
  final String? subcategoryName;
  final String? accountId;
  final String? accountName;

  Transaction(
      {this.id,
      this.budgetId,
      this.date,
      this.type,
      this.description = '',
      this.amount,
      this.categoryId,
      this.categoryName,
      this.subcategoryId,
      this.subcategoryName,
      this.accountName,
      this.accountId});

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  TransactionTile toTile() {
    return TransactionTile(
        id: this.id!,
        type: this.type!,
        amount: this.amount!,
        title: this.subcategoryName!,
        subtitle: this.accountName!,
        dateTime: this.date!,
        description: this.description!);
  }

  @override
  String toString() {
    return 'Transaction {id: $id, date: $date, type: $type, description: $description, amount: $amount, categoryId: $categoryId, sub: $subcategoryId, acc: $accountId';
  }
}
