import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../budgets.dart';

part 'budget.g.dart';

@JsonSerializable(explicitToJson: true)
class Budget{
  final String id;
  final List<Category> categoryList;
  final List<Account> accountList;

  Budget({this.id = '', this.categoryList = const [], this.accountList = const[]});

  factory Budget.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,) {
    final data = snapshot.data();
    return Budget(
      id: data?['id'],
      categoryList: (data?['categoryList'] as List<dynamic>?)
            ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
            .toList() ?? const [],
      accountList: (data?['accountList'] as List<dynamic>?)
          ?.map((e) => Account.fromJson(e as Map<String, dynamic>))
          .toList() ?? const [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'accountList': accountList.map((acc) => acc.toJson()).toList(),
      'categoryList': categoryList.map((cat) => cat.toJson()).toList(),
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) =>
      _$BudgetFromJson(json);

  Map<String, dynamic> toJson() => _$BudgetToJson(this);
}
