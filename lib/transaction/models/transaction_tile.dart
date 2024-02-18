
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../budgets/budgets.dart';
import '../transaction.dart';

part 'transaction_tile.g.dart';

@JsonSerializable(explicitToJson: true)
class TransactionTile extends Equatable {
  final String id;
  final TransactionType type;
  final double amount;
  final String title;
  final String subtitle;
  final Category? category;
  final Subcategory? subcategory;
  final Account? fromAccount;
  final Account? toAccount;
  final DateTime dateTime;
  final String description;

  const TransactionTile(
      {required this.id,
      required this.type,
      required this.amount,
      required this.title,
      required this.subtitle,
      this.category,
      this.subcategory,
      this.fromAccount,
      this.toAccount,
      required this.dateTime,
      required this.description});

  factory TransactionTile.fromJson(Map<String, dynamic> json) =>
      _$TransactionTileFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionTileToJson(this);

  @override
  List<Object?> get props => [id, amount, fromAccount, toAccount, dateTime];
}
