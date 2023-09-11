import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../budgets.dart';

part 'account.g.dart';

@JsonSerializable(explicitToJson: true)
class Account extends Equatable{
  final String id;
  final String name;
  final String categoryName;
  final String currency;
  final double balance;
  final double initialBalance;
  final bool includeInTotal;
  final bool isExpanded;

  const Account({
    this.id = '',
    required this.name,
    required this.categoryName,
    this.currency = 'USD',
    required this.balance,
    required this.initialBalance,
    this.includeInTotal = true,
    this.isExpanded = false
  });

  Account copyWith({
    String? id,
    String? name,
    String? categoryId,
    String? currency,
    double? balance,
    double? initialBalance,
    bool? includeInTotal,
    bool? isExpanded,
  }){
    return Account(
        id: id ?? this.id,
        name: name ?? this.name,
        categoryName: categoryId ?? this.categoryName,
        currency: currency ?? this.currency,
        balance: balance ?? this.balance,
        initialBalance: initialBalance ?? this.initialBalance,
        includeInTotal: includeInTotal ?? this.includeInTotal,
        isExpanded: isExpanded ?? this.isExpanded
    );
  }

  String extendName(List<Category> categories){
    final category = categories.where((element) => element.name == this.categoryName).first;
    return '${category.name} / ${this.name}';
  }

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);
  Map<String, dynamic> toJson() => _$AccountToJson(this);

  @override
  List<Object?> get props => [id, name, balance, isExpanded];
}
