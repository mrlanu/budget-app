import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

import '../../categories/models/category.dart';

part 'account.g.dart';

@Collection(inheritance: false)
class Account extends Equatable{
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
    String? categoryId,
    String? currency,
    double? balance,
    double? initialBalance,
    bool? includeInTotal,
    bool? isExpanded,
  }){
    return Account(
        name: name ?? this.name,
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

  @override
  @ignore
  List<Object?> get props => [id, name, balance];
}
