// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: json['id'] as String,
      name: json['name'] as String,
      section: $enumDecode(_$SectionEnumMap, json['section']),
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'section': _$SectionEnumMap[instance.section]!,
    };

const _$SectionEnumMap = {
  Section.ACCOUNTS: 'ACCOUNTS',
  Section.EXPENSES: 'EXPENSES',
  Section.INCOME: 'INCOME',
};
