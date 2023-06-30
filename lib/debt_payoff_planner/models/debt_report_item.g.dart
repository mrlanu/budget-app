// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_report_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DebtReportItem _$DebtReportItemFromJson(Map<String, dynamic> json) =>
    DebtReportItem(
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      paid: json['paid'] as bool,
    );

Map<String, dynamic> _$DebtReportItemToJson(DebtReportItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'amount': instance.amount,
      'paid': instance.paid,
    };
