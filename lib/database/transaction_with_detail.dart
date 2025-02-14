import 'database.dart';

class TransactionWithDetails {
  final Transaction transaction;
  final Category category;
  final Subcategory subcategory;
  final Account fromAccount;
  final Account? toAccount;

  TransactionWithDetails({
    required this.transaction,
    required this.category,
    required this.subcategory,
    required this.fromAccount,
    required this.toAccount,
  });
}
