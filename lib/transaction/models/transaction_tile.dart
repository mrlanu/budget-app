import 'package:budget_app/database/database.dart';
import 'package:budget_app/transaction/models/transaction_type.dart';
import 'package:equatable/equatable.dart';

class TransactionTile extends Equatable {
  final int id;
  final TransactionType type;
  final double amount;
  final String title;
  final String subtitle;
  final Category? category;
  final String? subcategory;
  final String fromAccount;
  final String? toAccount;
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
      required this.fromAccount,
      this.toAccount,
      required this.dateTime,
      required this.description});

  @override
  List<Object?> get props =>
      [id, amount, category, fromAccount, toAccount, dateTime];
}
