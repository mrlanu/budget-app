import 'package:budget_app/database/database.dart';
import 'package:equatable/equatable.dart';

class AccountWithDetails extends Equatable{
  final int? id;
  final String name;
  final Category category;
  final String currency;
  final double balance;
  final double initialBalance;
  final bool includeInTotal;

  const AccountWithDetails({
    this.id,
    required this.name,
    required this.category,
    this.currency = 'USD',
    required this.balance,
    required this.initialBalance,
    this.includeInTotal = true,
  });

  AccountWithDetails copyWith({
    int? id,
    String? name,
    Category? category,
    String? currency,
    double? balance,
    double? initialBalance,
    bool? includeInTotal,
    bool? isExpanded,
  }){
    return AccountWithDetails(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      currency: currency ?? this.currency,
      balance: balance ?? this.balance,
      initialBalance: initialBalance ?? this.initialBalance,
      includeInTotal: includeInTotal ?? this.includeInTotal,
    );
  }

  String extendName(){
    return '${category.name} / ${this.name}';
  }

  @override
  List<Object?> get props => [id, name, category, balance, includeInTotal];
}
