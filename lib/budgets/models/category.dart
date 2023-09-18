import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:json_annotation/json_annotation.dart';

import '../budgets.dart';

part 'category.g.dart';

@JsonSerializable(explicitToJson: true)
class Category {
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
}
