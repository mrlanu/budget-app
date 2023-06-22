import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'summary_tile.g.dart';

@JsonSerializable()
class SummaryTile extends Equatable{
  final String id;
  final String name;
  final double total;
  final int iconCodePoint;

  const SummaryTile({
    required this.id,
    required this.name,
    required this.total,
    required this.iconCodePoint,
  });

  factory SummaryTile.fromJson(Map<String, dynamic> json) => _$SummaryTileFromJson(json);
  Map<String, dynamic> toJson() => _$SummaryTileToJson(this);

  @override
  List<Object> get props => [id, total, name, iconCodePoint];
}
