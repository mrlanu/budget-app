// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      id: json['id'] as String? ?? '',
      name: json['name'] as String,
      categoryId: json['categoryId'] as String,
      currency: json['currency'] as String? ?? 'USD',
      balance: (json['balance'] as num).toDouble(),
      initialBalance: (json['initialBalance'] as num).toDouble(),
      includeInTotal: json['includeInTotal'] as bool? ?? true,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'categoryId': instance.categoryId,
      'currency': instance.currency,
      'balance': instance.balance,
      'initialBalance': instance.initialBalance,
      'includeInTotal': instance.includeInTotal,
    };
