// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionView _$TransactionViewFromJson(Map<String, dynamic> json) =>
    TransactionView(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      subcategory: json['subcategory'] as String,
      account: json['account'] as String,
      accountType: json['accountType'] as String,
    );

Map<String, dynamic> _$TransactionViewToJson(TransactionView instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'type': instance.type,
      'description': instance.description,
      'amount': instance.amount,
      'category': instance.category,
      'subcategory': instance.subcategory,
      'account': instance.account,
      'accountType': instance.accountType,
    };
