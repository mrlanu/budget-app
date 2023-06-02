import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  final String? id;
  final String name;
  final String budgetId;
  final TransactionType transactionType;

  const Category(
      {this.id, required this.name, required this.budgetId, required this.transactionType});

  Category copyWith({String? id, String? name, String? budgetId, TransactionType? transactionType}) {
    return Category(
        id: id ?? this.id,
        name: name ?? this.name,
        budgetId: budgetId ?? this.budgetId,
        transactionType: transactionType ?? this.transactionType);
  }

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  @override
  String toString() {
    return 'Category{id: $id, name: $name, budgetId: $budgetId, type: $transactionType';
  }
}
