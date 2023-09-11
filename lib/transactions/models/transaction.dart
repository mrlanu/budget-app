import 'package:budget_app/transactions/models/transaction_tile.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../budgets/budgets.dart';

part 'transaction.g.dart';

@JsonSerializable(explicitToJson: true)
class Transaction {
  final String? id;
  final DateTime? date;
  final TransactionType? type;
  final String? description;
  final double? amount;
  final Category? category;
  final Subcategory? subcategory;
  final String? accountId;

  Transaction(
      {this.id,
      this.date,
      this.type,
      this.description = '',
      this.amount,
      this.category,
      this.subcategory,
      this.accountId});

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  factory Transaction.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,) {
    final data = snapshot.data();
    return Transaction.fromJson(data!);
  }

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  TransactionTile toTile(
      {required Category category,
      required Account account,
      required Subcategory subcategory}) {
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
    return 'Transaction {id: $id, date: $date, type: $type, description: $description, amount: $amount, categoryId: ${category?.name}, sub: ${subcategory?.name}, acc: $accountId';
  }
}
