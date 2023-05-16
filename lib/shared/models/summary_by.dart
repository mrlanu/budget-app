import 'package:json_annotation/json_annotation.dart';

part 'summary_by.g.dart';

@JsonSerializable()
class SummaryBy {
  final String id;
  final String name;
  final double total;
  final int iconCodePoint;

  const SummaryBy({
    required this.id,
    required this.name,
    required this.total,
    required this.iconCodePoint,
  });

  factory SummaryBy.fromJson(Map<String, dynamic> json) => _$SummaryByFromJson(json);
  Map<String, dynamic> toJson() => _$SummaryByToJson(this);
}
