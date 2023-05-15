// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategorySummary _$CategorySummaryFromJson(Map<String, dynamic> json) =>
    CategorySummary(
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      amount: json['amount'] as String,
      iconCodePoint: json['iconCodePoint'] as int,
    );

Map<String, dynamic> _$CategorySummaryToJson(CategorySummary instance) =>
    <String, dynamic>{
      'category': instance.category,
      'amount': instance.amount,
      'iconCodePoint': instance.iconCodePoint,
    };
