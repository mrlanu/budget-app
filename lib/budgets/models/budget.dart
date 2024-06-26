import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../accounts_list/models/account.dart';
import '../../categories/models/category.dart';
import '../../transaction/models/transaction_type.dart';

part 'budget.g.dart';

@JsonSerializable(explicitToJson: true)
class Budget extends Equatable{
  final String id;
  final List<Category> categoryList;
  final List<Account> accountList;

  const Budget(
      {this.id = '',
      this.categoryList = const [],
      this.accountList = const []});

  Category getCategoryById(String id) =>
      categoryList
          .where((cat) => cat.id == id)
          .first;

  Account getAccountById(String accountId) => accountList
        .firstWhere((acc) => acc.id == accountId);

  List<Category> getCategoriesByType(TransactionType type) =>
      categoryList
          .where((cat) => cat.type == type)
          .toList();


  Budget copyWith(
      {String? id, List<Category>? categoryList, List<Account>? accountList}) {
    return Budget(
        id: id ?? this.id,
        categoryList: categoryList ?? this.categoryList,
        accountList: accountList ?? this.accountList);
  }

  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);

  Map<String, dynamic> toJson() => _$BudgetToJson(this);

  @override
  List<Object?> get props => [id, categoryList, accountList];
}
