import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'account_model.g.dart';

@JsonSerializable()
class AccountModel {
  final String id;
  final String name;
  final String categoryId;
  final String currency;
  final double balance;
  final double initialBalance;
  final bool includeInTotal;
  final String? budgetId;

  AccountModel(
      {required this.id,
      required this.name,
      required this.categoryId,
      this.currency = 'USD',
      this.balance = 0,
      this.initialBalance = 0,
      this.includeInTotal = true,
      this.budgetId});

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}
