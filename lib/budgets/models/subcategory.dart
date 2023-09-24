import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subcategory.g.dart';

@JsonSerializable()
class Subcategory extends Equatable{
  final String id;
  final String name;

  const Subcategory({required this.id, required this.name});

  factory Subcategory.fromJson(Map<String, dynamic> json) =>
      _$SubcategoryFromJson(json);

  Subcategory copyWith({String? id, String? name}){
    return Subcategory(id: id ?? this.id, name: name ?? this.name);
  }

  Map<String, dynamic> toJson() => _$SubcategoryToJson(this);

  @override
  List<Object?> get props => [id, name];
}
