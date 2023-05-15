import 'package:json_annotation/json_annotation.dart';

import '../../accounts/models/account_brief.dart';
import 'category.dart';
import 'subcategory.dart';

part 'budget.g.dart';

@JsonSerializable()
class Budget {
  final String id;
  final String userId;
  final List<Category> categoryList;
  final List<Subcategory> subcategoryList;
  final List<AccountBrief> accountBriefList;

  const Budget(
      {required this.id,
      required this.userId,
      required this.categoryList,
      required this.subcategoryList,
      required this.accountBriefList});

  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);

  Map<String, dynamic> toJson() => _$BudgetToJson(this);
}
