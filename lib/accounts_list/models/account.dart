import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../categories/models/category.dart';

part 'account.g.dart';

@JsonSerializable(explicitToJson: true)
class Account extends Equatable{
  final String id;
  final String name;
  final String categoryId;
  final String currency;
  final double balance;
  final double initialBalance;
  final bool includeInTotal;

  const Account({
    this.id = '',
    required this.name,
    required this.categoryId,
    this.currency = 'USD',
    required this.balance,
    required this.initialBalance,
    this.includeInTotal = true,
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
        categoryId: categoryId ?? this.categoryId,
        currency: currency ?? this.currency,
        balance: balance ?? this.balance,
        initialBalance: initialBalance ?? this.initialBalance,
        includeInTotal: includeInTotal ?? this.includeInTotal,
    );
  }

  String extendName(List<Category> categories){
    final category = categories.where((element) => element.id == this.categoryId).first;
    return '${category.name} / ${this.name}';
  }

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);
  Map<String, dynamic> toJson() => _$AccountToJson(this);

  @override
  List<Object?> get props => [id, name, balance];
}
