import 'package:json_annotation/json_annotation.dart';

part 'section_summary.g.dart';

@JsonSerializable()
class SectionSummary {
  final String name;
  final String amount;
  final int iconCodePoint;

  const SectionSummary({
    required this.name,
    required this.amount,
    required this.iconCodePoint,
  });

  factory SectionSummary.fromJson(Map<String, dynamic> json) => _$SectionSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$SectionSummaryToJson(this);
}
