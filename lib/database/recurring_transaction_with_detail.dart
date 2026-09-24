import 'package:equatable/equatable.dart';
import 'package:qruto_budget/database/database.dart';
import 'package:qruto_budget/database/tables.dart';
import 'package:qruto_budget/transaction/models/transaction_type.dart';

class RecurringTransactionWithDetails extends Equatable {
  final int id;
  final double amount;
  final String description;
  final TransactionType type;
  final RecurringFrequency frequency;
  final DateTime nextDate;
  final bool isActive;
  final Category category;
  final Subcategory? subcategory;
  final Account fromAccount;

  const RecurringTransactionWithDetails({
    required this.id,
    required this.amount,
    required this.description,
    required this.type,
    required this.frequency,
    required this.nextDate,
    required this.isActive,
    required this.category,
    this.subcategory,
    required this.fromAccount,
  });

  @override
  List<Object?> get props => [
        id,
        amount,
        description,
        type,
        frequency,
        nextDate,
        isActive,
        category,
        subcategory,
        fromAccount,
      ];
}
