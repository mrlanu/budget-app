// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_payoff_strategy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DebtPayoffStrategy _$DebtPayoffStrategyFromJson(Map<String, dynamic> json) =>
    DebtPayoffStrategy(
      totalDuration: (json['totalDuration'] as num).toInt(),
      totalInterest: (json['totalInterest'] as num).toDouble(),
      debtFreeDate: DateTime.parse(json['debtFreeDate'] as String),
      reports: (json['reports'] as List<dynamic>)
          .map((e) => DebtStrategyReport.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DebtPayoffStrategyToJson(DebtPayoffStrategy instance) =>
    <String, dynamic>{
      'totalDuration': instance.totalDuration,
      'totalInterest': instance.totalInterest,
      'debtFreeDate': instance.debtFreeDate.toIso8601String(),
      'reports': instance.reports,
    };
