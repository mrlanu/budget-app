// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: json['id'] as String,
      name: json['name'] as String,
      iconCode: (json['iconCode'] as num?)?.toInt() ?? 0,
      subcategoryList: (json['subcategoryList'] as List<dynamic>?)
              ?.map((e) => Subcategory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'iconCode': instance.iconCode,
      'subcategoryList':
          instance.subcategoryList.map((e) => e.toJson()).toList(),
      'type': _$TransactionTypeEnumMap[instance.type]!,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.EXPENSE: 'EXPENSE',
  TransactionType.INCOME: 'INCOME',
  TransactionType.ACCOUNT: 'ACCOUNT',
  TransactionType.TRANSFER: 'TRANSFER',
};
