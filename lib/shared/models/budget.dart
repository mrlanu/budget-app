import 'package:json_annotation/json_annotation.dart';

import '../../categories/models/category.dart';
import '../../categories/models/subcategory.dart';

part 'budget.g.dart';

@JsonSerializable()
class Budget {
  final String id;
  final String userId;
  final List<Category> categoryList;
  final List<Subcategory> subcategoryList;

  const Budget(
      {required this.id,
      required this.userId,
      required this.categoryList,
      required this.subcategoryList});

  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);
  Map<String, dynamic> toJson() => _$BudgetToJson(this);
}
