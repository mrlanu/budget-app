import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subcategory.g.dart';

@JsonSerializable()
@Embedded(inheritance: false)
class Subcategory extends Equatable{
  final String id;
  final String name;

  const Subcategory({this.id = '', this.name = ''});

  factory Subcategory.fromJson(Map<String, dynamic> json) =>
      _$SubcategoryFromJson(json);

  Subcategory copyWith({String? id, String? name}){
    return Subcategory(id: id ?? this.id, name: name ?? this.name);
  }

  Map<String, dynamic> toJson() => _$SubcategoryToJson(this);

  @override
  @ignore
  List<Object?> get props => [id, name];
}
