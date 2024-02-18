import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../transaction/transaction.dart';
import '../budgets.dart';

part 'category.g.dart';

@JsonSerializable(explicitToJson: true)
class Category extends Equatable {
  final String id;
  final String name;
  final int iconCode;
  final List<Subcategory> subcategoryList;
  final TransactionType type;

  const Category(
      {required this.id,
      required this.name,
      this.iconCode = 0,
      this.subcategoryList = const [],
      required this.type});

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  Category copyWith(
      {String? id,
      String? name,
      int? iconCode,
      List<Subcategory>? subcategoryList,
      TransactionType? type}) {
    return Category(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        iconCode: iconCode ?? this.iconCode,
        subcategoryList: subcategoryList ?? this.subcategoryList);
  }

  @override
  List<Object?> get props => [id, name, subcategoryList];
}
