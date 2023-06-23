// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      id: json['id'] as String?,
      budgetId: json['budgetId'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      type: $enumDecodeNullable(_$TransactionTypeEnumMap, json['type']),
      description: json['description'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble(),
      categoryId: json['categoryId'] as String?,
      subcategoryId: json['subcategoryId'] as String?,
      accountId: json['accountId'] as String?,
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'budgetId': instance.budgetId,
      'date': instance.date?.toIso8601String(),
      'type': _$TransactionTypeEnumMap[instance.type],
      'description': instance.description,
      'amount': instance.amount,
      'categoryId': instance.categoryId,
      'subcategoryId': instance.subcategoryId,
      'accountId': instance.accountId,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.EXPENSE: 'EXPENSE',
  TransactionType.INCOME: 'INCOME',
  TransactionType.TRANSFER: 'TRANSFER',
  TransactionType.ACCOUNT: 'ACCOUNT',
};
