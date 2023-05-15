
import 'package:json_annotation/json_annotation.dart';

import 'category.dart';

part 'category_summary.g.dart';

@JsonSerializable()
class CategorySummary {
  final Category category;
  final String amount;
  final int iconCodePoint;

  const CategorySummary({
    required this.category,
    required this.amount,
    required this.iconCodePoint,
  });

  factory CategorySummary.fromJson(Map<String, dynamic> json) => _$CategorySummaryFromJson(json);
  Map<String, dynamic> toJson() => _$CategorySummaryToJson(this);
}
