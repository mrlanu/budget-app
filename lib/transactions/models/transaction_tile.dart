import 'package:budget_app/transactions/models/transaction_type.dart';

class TransactionTile {
  final String id;
  final TransactionType type;
  final double amount;
  final String title;
  final String subtitle;
  final DateTime dateTime;
  final String description;

  const TransactionTile(
      {required this.id,
      required this.type,
      required this.amount,
      required this.title,
      required this.subtitle,
      required this.dateTime,
      required this.description});
}
