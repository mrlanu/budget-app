import 'package:equatable/equatable.dart';

import '../transaction/models/transaction_type.dart';
import 'database.dart';

class TransactionWithDetails extends Equatable {
  final int id;
  final double amount;
  final DateTime date;
  final String description;
  final TransactionType type;
  final Category? category;
  final Subcategory? subcategory;
  final Account fromAccount;
  final Account? toAccount;

  TransactionWithDetails({
    required this.id,
    required this.amount,
    required this.date,
    required this.description,
    required this.type,
    required this.category,
    required this.subcategory,
    required this.fromAccount,
    required this.toAccount,
  });

  @override
  List<Object?> get props => [
        id,
        amount,
        date,
        description,
        type,
        category,
        subcategory,
        fromAccount,
        toAccount
      ];
}
