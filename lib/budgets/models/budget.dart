import 'package:json_annotation/json_annotation.dart';

import '../budgets.dart';

part 'budget.g.dart';

@JsonSerializable(explicitToJson: true)
class Budget {
  final String id;
  final List<Category> categoryList;
  final List<Account> accountList;

  const Budget(
      {this.id = '',
      this.categoryList = const [],
      this.accountList = const []});

  Budget copyWith(
      {String? id, List<Category>? categoryList, List<Account>? accountList}) {
    return Budget(
        id: id ?? this.id,
        categoryList: categoryList ?? this.categoryList,
        accountList: accountList ?? this.accountList);
  }

  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);

  Map<String, dynamic> toJson() => _$BudgetToJson(this);
}
