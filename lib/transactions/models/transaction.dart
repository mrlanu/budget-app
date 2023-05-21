import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

@JsonSerializable()
class Transaction {
  final String? id;
  final String budgetId;
  final DateTime date;
  final TransactionType type;
  final String description;
  final double amount;
  final String categoryId;
  final String subcategoryId;
  final String accountId;

  const Transaction(
      {required this.id,
      required this.budgetId,
      required this.date,
      required this.type,
      this.description = '',
      required this.amount,
      required this.categoryId,
      required this.subcategoryId,
      required this.accountId});

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  @override
  String toString() {
    return 'Transaction {id: $id, budgetId: $budgetId, date: $date, type: $type, description: $description, amount: $amount, categoryId: $categoryId, sub: $subcategoryId, acc: $accountId';
  }
}
