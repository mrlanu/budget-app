// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transfer _$TransferFromJson(Map<String, dynamic> json) => Transfer(
      id: json['id'] as String?,
      date: DateTime.parse(json['date'] as String),
      fromAccountId: json['fromAccountId'] as String,
      toAccountId: json['toAccountId'] as String,
      amount: (json['amount'] as num).toDouble(),
      budgetId: json['budgetId'] as String,
      notes: json['notes'] as String?,
);

Map<String, dynamic> _$TransferToJson(Transfer instance) => <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'fromAccountId': instance.fromAccountId,
      'toAccountId': instance.toAccountId,
      'amount': instance.amount,
      'budgetId': instance.budgetId,
      'notes': instance.notes,
};
