import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../categories/models/category.dart';

part 'account.g.dart';

@JsonSerializable()
class Account extends Equatable{
  final String? id;
  final String name;
  final String categoryId;
  final String currency;
  final double balance;
  final double initialBalance;
  final bool includeInTotal;
  final String budgetId;

  const Account({
    this.id,
    required this.name,
    required this.categoryId,
    this.currency = 'USD',
    required this.balance,
    required this.initialBalance,
    this.includeInTotal = true,
    required this.budgetId
  });

  String extendName(List<Category> categories){
    final category = categories.where((element) => element.id == this.categoryId).first;
    return '${category.name} / ${this.name}';
  }

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);
  Map<String, dynamic> toJson() => _$AccountToJson(this);

  @override
  List<Object?> get props => [id, name, balance];
}
