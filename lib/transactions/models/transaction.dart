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

  Transaction.empty()
      : this();

  Transaction.create(
      {required String budgetId,
      required DateTime date,
      required TransactionType type,
      required String description,
      required double amount,
      required String categoryId,
      required String categoryName,
      required String subcategoryId,
      required String subcategoryName,
      required String accountName,
      required String accountId})
      : this(
            budgetId: budgetId,
            date: date,
            type: type,
            description: description,
            amount: amount,
            categoryId: categoryId,
            categoryName: categoryName,
            subcategoryId: subcategoryId,
            subcategoryName: subcategoryName,
            accountId: accountId,
            accountName: accountName);

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

/*@override
  String toString() {
    return 'Transaction {id: $id, budgetId: $budgetId, date: $date, type: $type, description: $description, amount: $amount, categoryId: $categoryId, sub: $subcategoryId, acc: $accountId';
  }*/
}
