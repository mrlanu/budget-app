import 'package:budget_app/shared/models/transaction_interface.dart';
import 'package:budget_app/transactions/models/transaction_tile.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../budgets/budgets.dart';

part 'transaction.g.dart';

@JsonSerializable(explicitToJson: true)
class Transaction implements ITransaction{
  final String? id;
  final DateTime? date;
  final TransactionType? type;
  final String? description;
  final double? amount;
  final String? categoryId;
  final String? subcategoryId;
  final String? accountId;

  Transaction(
      {this.id,
      this.date,
      this.type,
      this.description = '',
      this.amount,
      this.categoryId,
      this.subcategoryId,
      this.accountId});

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  factory Transaction.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,) {
    final data = snapshot.data();
    return Transaction(
      id: snapshot.id,
      date:
      data?['date'] == null ? null : (data?['date'] as Timestamp).toDate(),
      type: $enumDecodeNullable(_$TransactionTypeEnumMap, data?['type']),
      description: data?['description'] as String? ?? '',
      amount: (data?['amount'] as num?)?.toDouble(),
      categoryId: data?['categoryId'] as String?,
      subcategoryId: data?['subcategoryId'] as String?,
      accountId: data?['accountId'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() => <String, dynamic>{
    'date': Timestamp.fromDate(date!),
    'type': _$TransactionTypeEnumMap[type],
    'description': description,
    'amount': amount,
    'categoryId': categoryId,
    'subcategoryId': subcategoryId,
    'accountId': accountId,
  };

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
    return 'Transaction {id: $id, date: $date, type: $type, description: $description, amount: $amount, categoryId: $categoryId, sub: $subcategoryId, acc: $accountId';
  }

  @override
  bool isTransaction() => true;

  @override
  String get getId => id!;
}
