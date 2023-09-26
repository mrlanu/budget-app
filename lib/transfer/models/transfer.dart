import 'package:budget_app/shared/models/transaction_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../budgets/budgets.dart';
import '../../transactions/models/transaction_tile.dart';
import '../../transactions/models/transaction_type.dart';

part 'transfer.g.dart';

@JsonSerializable(explicitToJson: true)
class Transfer extends Equatable implements ITransaction {
  final String? id;
  final DateTime date;
  final String fromAccountId;
  final String toAccountId;
  final double amount;
  final String? notes;

  Transfer(
      {this.id,
      required this.date,
      required this.fromAccountId,
      required this.toAccountId,
      required this.amount,
      this.notes});

  Transfer copyWith(
      {String? id,
      DateTime? date,
      String? fromAccountId,
      String? toAccountId,
      double? amount,
      String? budgetId,
      String? notes}) {
    return Transfer(
      id: id ?? this.id,
      date: date ?? this.date,
      fromAccountId: fromAccountId ?? this.fromAccountId,
      toAccountId: toAccountId ?? this.toAccountId,
      amount: amount ?? this.amount,
      notes: notes ?? this.notes,
    );
  }

  factory Transfer.fromJson(Map<String, dynamic> json) =>
      _$TransferFromJson(json);

  factory Transfer.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Transfer(
      id: snapshot.id,
      date: DateTime.parse(data?['date'] as String),
      fromAccountId: data?['fromAccountId'] as String,
      toAccountId: data?['toAccountId'] as String,
      amount: (data?['amount'] as num).toDouble(),
      notes: data?['notes'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() => <String, dynamic>{
    'date': date.toIso8601String(),
    'fromAccountId': fromAccountId,
    'toAccountId': toAccountId,
    'amount': amount,
    'notes': notes,
  };


  Map<String, dynamic> toJson() => _$TransferToJson(this);

  @override
  List<Object?> get props => [id];

  List<TransactionTile> toTiles({required Account fromAccount, required Account toAccount}) {
    return List.of(
    [TransactionTile(
        id: this.id!,
        type: TransactionType.TRANSFER,
        amount: this.amount,
        title: 'Transfer in',
        subtitle: 'from ${fromAccount.name}',
        dateTime: date,
        description: this.notes!,
        fromAccount: fromAccount,
        toAccount: toAccount),
    TransactionTile(
        id: this.id!,
        type: TransactionType.TRANSFER,
        amount: this.amount,
        title: 'Transfer out',
        subtitle: 'to ${toAccount.name}',
        dateTime: date,
        description: this.notes!,
        fromAccount: fromAccount,
        toAccount: toAccount)]);
  }

  @override
  bool isTransaction() => false;
}
