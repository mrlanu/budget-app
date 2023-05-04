// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      currency: json['currency'] as String? ?? 'USD',
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      initialBalance: (json['initialBalance'] as num?)?.toDouble() ?? 0,
      includeInTotal: json['includeInTotal'] as bool? ?? true,
      budgetId: json['budgetId'] as String?,
    );

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'currency': instance.currency,
      'balance': instance.balance,
      'initialBalance': instance.initialBalance,
      'includeInTotal': instance.includeInTotal,
      'budgetId': instance.budgetId,
    };
