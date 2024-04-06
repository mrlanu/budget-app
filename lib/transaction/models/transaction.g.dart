// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      id: json['id'] as String?,
      budgetId: json['budgetId'] as String,
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] as num).toDouble(),
      type: $enumDecodeNullable(_$TransactionTypeEnumMap, json['type']),
      description: json['description'] as String? ?? '',
      categoryId: json['categoryId'] as String?,
      subcategoryId: json['subcategoryId'] as String?,
      fromAccountId: json['fromAccountId'] as String,
      toAccountId: json['toAccountId'] as String?,
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budgetId': instance.budgetId,
      'date': instance.date.toIso8601String(),
      'type': _$TransactionTypeEnumMap[instance.type],
      'amount': instance.amount,
      'fromAccountId': instance.fromAccountId,
      'toAccountId': instance.toAccountId,
      'description': instance.description,
      'categoryId': instance.categoryId,
      'subcategoryId': instance.subcategoryId,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.EXPENSE: 'EXPENSE',
  TransactionType.INCOME: 'INCOME',
  TransactionType.TRANSFER: 'TRANSFER',
  TransactionType.ACCOUNT: 'ACCOUNT',
};
