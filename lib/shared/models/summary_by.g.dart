// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary_by.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SummaryBy _$SummaryByFromJson(Map<String, dynamic> json) => SummaryBy(
      id: json['id'] as String,
      name: json['name'] as String,
      total: (json['total'] as num).toDouble(),
      iconCodePoint: json['iconCodePoint'] as int,
    );

Map<String, dynamic> _$SummaryByToJson(SummaryBy instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'total': instance.total,
      'iconCodePoint': instance.iconCodePoint,
    };
