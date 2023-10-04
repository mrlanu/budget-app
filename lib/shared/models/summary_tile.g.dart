// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary_tile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SummaryTile _$SummaryTileFromJson(Map<String, dynamic> json) => SummaryTile(
      id: json['id'] as String,
      name: json['name'] as String,
      total: (json['total'] as num).toDouble(),
      transactionTiles: (json['transactionTiles'] as List<dynamic>?)
              ?.map((e) => TransactionTile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      iconCodePoint: json['iconCodePoint'] as int,
      isExpanded: json['isExpanded'] as bool? ?? false,
    );

Map<String, dynamic> _$SummaryTileToJson(SummaryTile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'total': instance.total,
      'transactionTiles':
          instance.transactionTiles.map((e) => e.toJson()).toList(),
      'iconCodePoint': instance.iconCodePoint,
      'isExpanded': instance.isExpanded,
    };
