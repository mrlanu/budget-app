import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../categories/models/category.dart';

part 'account.g.dart';

@JsonSerializable(explicitToJson: true)
@Embedded(inheritance: false)
class Account extends Equatable{
  final String id;
  final String name;
  final String category;
  final String currency;
  final double balance;
  final double initialBalance;
  final bool includeInTotal;

  const Account({
    this.id = '',
    this.name = 'New Acc',
    this.category = '',
    this.currency = 'USD',
    this.balance = 0.0,
    this.initialBalance = 0.0,
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
        category: categoryId ?? this.category,
        currency: currency ?? this.currency,
        balance: balance ?? this.balance,
        initialBalance: initialBalance ?? this.initialBalance,
        includeInTotal: includeInTotal ?? this.includeInTotal,
    );
  }

  String extendName(List<Category> categories){
    final category = categories.where((element) => element.id == this.category).first;
    return '${category.name} / ${this.name}';
  }

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);
  Map<String, dynamic> toJson() => _$AccountToJson(this);

  @override
  @ignore
  List<Object?> get props => [id, name, balance];
}
