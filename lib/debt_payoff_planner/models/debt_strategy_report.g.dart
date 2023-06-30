// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_strategy_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DebtStrategyReport _$DebtStrategyReportFromJson(Map<String, dynamic> json) =>
    DebtStrategyReport(
      duration: json['duration'] as int,
      extraPayments: (json['extraPayments'] as List<dynamic>)
          .map((e) => DebtReportItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      minPayments: (json['minPayments'] as List<dynamic>)
          .map((e) => DebtReportItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DebtStrategyReportToJson(DebtStrategyReport instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'extraPayments': instance.extraPayments,
      'minPayments': instance.minPayments,
    };
