import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subcategory.g.dart';

@JsonSerializable()
class Subcategory extends Equatable{
  final String? id;
  final String name;
  final String categoryId;
  final String budgetId;

  const Subcategory(
      {this.id,
      required this.name,
      required this.categoryId,
      required this.budgetId});

  Subcategory copyWith(
      {String? id, String? name, String? categoryId, String? budgetId}) {
    return Subcategory(
        id: id ?? this.id,
        name: name ?? this.name,
        categoryId: categoryId ?? this.categoryId,
        budgetId: budgetId ?? this.budgetId);
  }

  factory Subcategory.fromJson(Map<String, dynamic> json) =>
      _$SubcategoryFromJson(json);

  Map<String, dynamic> toJson() => _$SubcategoryToJson(this);

  @override
  List<Object?> get props => [id, name];
}
