// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subcategory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subcategory _$SubcategoryFromJson(Map<String, dynamic> json) => Subcategory(
      id: json['id'] as String?,
      name: json['name'] as String,
      categoryId: json['categoryId'] as String,
      budgetId: json['budgetId'] as String,
    );

Map<String, dynamic> _$SubcategoryToJson(Subcategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'categoryId': instance.categoryId,
      'budgetId': instance.budgetId,
    };
