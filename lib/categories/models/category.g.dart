// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: json['id'] as String?,
      name: json['name'] as String,
      budgetId: json['budgetId'] as String,
      transactionType:
          $enumDecode(_$TransactionTypeEnumMap, json['transactionType']),
      iconCode: json['iconCode'] as int?,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'budgetId': instance.budgetId,
      'transactionType': _$TransactionTypeEnumMap[instance.transactionType]!,
      'iconCode': instance.iconCode,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.EXPENSE: 'EXPENSE',
  TransactionType.INCOME: 'INCOME',
  TransactionType.TRANSFER: 'TRANSFER',
  TransactionType.ACCOUNT: 'ACCOUNT',
};
