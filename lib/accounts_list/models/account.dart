import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

import '../../categories/models/category.dart';

part 'account.g.dart';

@Collection(inheritance: false)
class Account extends Equatable {
  final Id? id;
  final String name;
  final category = IsarLink<Category>();
  final String currency;
  final double balance;
  final double initialBalance;
  final bool includeInTotal;

  Account({
    this.id,
    this.name = 'New Acc',
    this.currency = 'USD',
    this.balance = 0.0,
    this.initialBalance = 0.0,
    this.includeInTotal = true,
  });

  Account copyWith({
    String? name,
    String? currency,
    double? balance,
    double? initialBalance,
    IsarLink<Category>? category,
    bool? includeInTotal,
  }) {
    return Account(
      id: this.id,
      name: name ?? this.name,
      currency: currency ?? this.currency,
      balance: balance ?? this.balance,
      initialBalance: initialBalance ?? this.initialBalance,
      includeInTotal: includeInTotal ?? this.includeInTotal,
    )..category.value = category?.value ?? this.category.value;
  }

  String extendName(List<Category> categories) {
    final category = categories
        .where((element) => element.id == this.category.value?.id)
        .first;
    return '${category.name} / ${this.name}';
  }

  @override
  @ignore
  List<Object?> get props => [id, name, balance];
}