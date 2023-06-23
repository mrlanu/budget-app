import 'package:budget_app/accounts/models/account.dart';
import 'package:budget_app/categories/models/category.dart';
import 'package:budget_app/shared/models/subcategory.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:equatable/equatable.dart';

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

  @override
  List<Object?> get props => [id, amount, fromAccount, toAccount, dateTime];
}
