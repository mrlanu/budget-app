// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_tile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionTile _$TransactionTileFromJson(Map<String, dynamic> json) =>
    TransactionTile(
      id: json['id'] as String,
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      amount: (json['amount'] as num).toDouble(),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      subcategory: json['subcategory'] == null
          ? null
          : Subcategory.fromJson(json['subcategory'] as Map<String, dynamic>),
      fromAccount: json['fromAccount'] == null
          ? null
          : Account.fromJson(json['fromAccount'] as Map<String, dynamic>),
      toAccount: json['toAccount'] == null
          ? null
          : Account.fromJson(json['toAccount'] as Map<String, dynamic>),
      dateTime: DateTime.parse(json['dateTime'] as String),
      description: json['description'] as String,
    );

Map<String, dynamic> _$TransactionTileToJson(TransactionTile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'amount': instance.amount,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'category': instance.category?.toJson(),
      'subcategory': instance.subcategory?.toJson(),
      'fromAccount': instance.fromAccount?.toJson(),
      'toAccount': instance.toAccount?.toJson(),
      'dateTime': instance.dateTime.toIso8601String(),
      'description': instance.description,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.EXPENSE: 'EXPENSE',
  TransactionType.INCOME: 'INCOME',
  TransactionType.TRANSFER: 'TRANSFER',
  TransactionType.ACCOUNT: 'ACCOUNT',
};
