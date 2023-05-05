// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SectionSummary _$SectionSummaryFromJson(Map<String, dynamic> json) =>
    SectionSummary(
      name: json['name'] as String,
      amount: json['amount'] as String,
      iconCodePoint: json['iconCodePoint'] as int,
    );

Map<String, dynamic> _$SectionSummaryToJson(SectionSummary instance) =>
    <String, dynamic>{
      'name': instance.name,
      'amount': instance.amount,
      'iconCodePoint': instance.iconCodePoint,
    };
