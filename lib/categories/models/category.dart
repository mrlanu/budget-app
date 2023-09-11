import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category extends Equatable {
  final String? id;
  final String name;
  final String budgetId;
  final TransactionType transactionType;
  final int? iconCode;

  const Category(
      {this.id,
      required this.name,
      required this.budgetId,
      required this.transactionType,
      this.iconCode});

  Category copyWith(
      {String? id,
      String? name,
      String? budgetId,
      TransactionType? transactionType,
      int? iconCode}) {
    return Category(
        id: id ?? this.id,
        name: name ?? this.name,
        budgetId: budgetId ?? this.budgetId,
        transactionType: transactionType ?? this.transactionType,
        iconCode: iconCode ?? this.iconCode);
  }

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  /*@override
  String toString() {
    return 'Category{id: $id, name: $name, budgetId: $budgetId, type: $transactionType';
  }*/

  @override
  List<Object?> get props => [id, name];
}
