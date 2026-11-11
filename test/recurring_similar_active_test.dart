import 'package:flutter_test/flutter_test.dart';
import 'package:qruto_budget/database/database.dart';
import 'package:qruto_budget/database/recurring_transaction_with_detail.dart';
import 'package:qruto_budget/database/tables.dart';
import 'package:qruto_budget/recurring/repository/recurring_repository.dart';
import 'package:qruto_budget/transaction/models/transaction_type.dart';

void main() {
  Category category({int id = 1, String name = 'Salary'}) => Category(
        id: id,
        name: name,
        iconCode: 0,
        type: TransactionType.INCOME,
      );

  Account account({int id = 10, String name = 'Checking'}) => Account(
        id: id,
        name: name,
        balance: 0,
        initialBalance: 0,
        categoryId: 99,
        includeInTotal: true,
      );

  RecurringTransactionWithDetails item({
    required int id,
    required TransactionType type,
    required Category category,
    required Account account,
    bool isActive = true,
  }) {
    return RecurringTransactionWithDetails(
      id: id,
      amount: 100,
      description: '',
      type: type,
      frequency: RecurringFrequency.weekly,
      nextDate: DateTime(2026, 1, 1),
      isActive: isActive,
      category: category,
      fromAccount: account,
    );
  }

  group('RecurringRepositoryDrift.filterSimilarActive', () {
    final salary = category();
    final checking = account();

    test('returns active match with same type, category, and account', () {
      final items = [
        item(
          id: 1,
          type: TransactionType.INCOME,
          category: salary,
          account: checking,
        ),
      ];

      final matches = RecurringRepositoryDrift.filterSimilarActive(
        items,
        type: TransactionType.INCOME,
        categoryId: salary.id,
        fromAccountId: checking.id,
      );

      expect(matches.map((m) => m.id), [1]);
    });

    test('excludes paused templates', () {
      final items = [
        item(
          id: 1,
          type: TransactionType.INCOME,
          category: salary,
          account: checking,
          isActive: false,
        ),
      ];

      final matches = RecurringRepositoryDrift.filterSimilarActive(
        items,
        type: TransactionType.INCOME,
        categoryId: salary.id,
        fromAccountId: checking.id,
      );

      expect(matches, isEmpty);
    });

    test('excludes different type, category, or account', () {
      final items = [
        item(
          id: 1,
          type: TransactionType.EXPENSE,
          category: salary,
          account: checking,
        ),
        item(
          id: 2,
          type: TransactionType.INCOME,
          category: category(id: 2, name: 'Bonus'),
          account: checking,
        ),
        item(
          id: 3,
          type: TransactionType.INCOME,
          category: salary,
          account: account(id: 11, name: 'Savings'),
        ),
      ];

      final matches = RecurringRepositoryDrift.filterSimilarActive(
        items,
        type: TransactionType.INCOME,
        categoryId: salary.id,
        fromAccountId: checking.id,
      );

      expect(matches, isEmpty);
    });
  });
}
