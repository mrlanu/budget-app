import 'package:json_annotation/json_annotation.dart';

part 'subcategory.g.dart';

@JsonSerializable()
class Subcategory {
  final String? id;
  final String name;
  final String categoryId;

  const Subcategory({this.id, required this.name, required this.categoryId});

  Subcategory copyWith({String? id, String? name, String? categoryId}) {
    return Subcategory(
        id: id ?? this.id,
        name: name ?? this.name,
        categoryId: categoryId ?? this.categoryId);
  }

  factory Subcategory.fromJson(Map<String, dynamic> json) =>
      _$SubcategoryFromJson(json);

  Map<String, dynamic> toJson() => _$SubcategoryToJson(this);
}
