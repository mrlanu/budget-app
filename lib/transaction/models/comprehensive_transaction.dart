import 'package:equatable/equatable.dart';

import '../../accounts_list/models/account.dart';
import '../../categories/models/category.dart';
import '../../subcategories/models/subcategory.dart';
import '../transaction.dart';

class ComprehensiveTransaction extends Equatable {
  final int id;
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

  const ComprehensiveTransaction(
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

  Transaction toTransaction() {
    return Transaction.fromComprehensive(comprehensiveTransaction: this);
  }

  @override
  List<Object?> get props => [
        id,
        amount,
        fromAccount,
        toAccount,
        category,
        subcategory,
        description,
        toAccount,
        dateTime
      ];
}
