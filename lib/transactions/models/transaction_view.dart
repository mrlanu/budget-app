import 'package:json_annotation/json_annotation.dart';

part 'transaction_view.g.dart';

@JsonSerializable()
class TransactionView {
  final String id;
  final DateTime date;
  final String type;
  final String description;
  final double amount;
  final String category;
  final String subcategory;
  final String account;
  final String accountType;

  TransactionView(
      {required this.id,
      required this.date,
      required this.type,
      required this.description,
      required this.amount,
      required this.category,
      required this.subcategory,
      required this.account,
      required this.accountType});

  factory TransactionView.fromJson(Map<String, dynamic> json) =>
      _$TransactionViewFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionViewToJson(this);
}
