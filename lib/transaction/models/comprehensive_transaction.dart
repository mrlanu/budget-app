import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../budgets/budgets.dart';
import '../transaction.dart';

part 'comprehensive_transaction.g.dart';

@JsonSerializable(explicitToJson: true)
class ComprehensiveTransaction extends Equatable {
  final String id;
  final String budgetId;
  final TransactionType type;
  final double amount;
  final String title;
  final String subtitle;
  final Category? category;
  final Subcategory? subcategory;
  final Account? fromAccount;
  final Account? toAccount;
  final DateTime dateTime;
  final String description;

  const ComprehensiveTransaction(
      {required this.id,
      required this.budgetId,
      required this.type,
      required this.amount,
      required this.title,
      required this.subtitle,
      this.category,
      this.subcategory,
      this.fromAccount,
      this.toAccount,
      required this.dateTime,
      required this.description});

  factory ComprehensiveTransaction.fromJson(Map<String, dynamic> json) =>
      _$ComprehensiveTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$ComprehensiveTransactionToJson(this);

  Transaction toTransaction() {
    return this.type == TransactionType.TRANSFER
        ? Transaction(
            id: id,
            budgetId: budgetId,
            date: dateTime,
            amount: amount,
            fromAccountId: fromAccount!.id,
            toAccountId: toAccount!.id,
            description: description,
            type: type,
          )
        : Transaction(
            id: id,
            budgetId: budgetId,
            date: dateTime,
            amount: amount,
            categoryId: category!.id,
            subcategoryId: subcategory!.id,
            description: description,
            type: type,
            fromAccountId: fromAccount!.id);
  }

  @override
  List<Object?> get props =>
      [id, budgetId, amount, fromAccount, toAccount, dateTime];
}
