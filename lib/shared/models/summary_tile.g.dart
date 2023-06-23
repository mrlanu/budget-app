// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary_tile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SummaryTile _$SummaryTileFromJson(Map<String, dynamic> json) => SummaryTile(
      id: json['id'] as String,
      name: json['name'] as String,
      total: (json['total'] as num).toDouble(),
      iconCodePoint: json['iconCodePoint'] as int,
    );

Map<String, dynamic> _$SummaryTileToJson(SummaryTile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'total': instance.total,
      'iconCodePoint': instance.iconCodePoint,
    };
