import 'package:flutter_test/flutter_test.dart';
import 'package:qruto_budget/database/tables.dart';
import 'package:qruto_budget/recurring/repository/recurring_repository.dart';

void main() {
  group('RecurringRepositoryDrift.nextOccurrenceAfter', () {
    test('weekly advances by 7 days', () {
      final next = RecurringRepositoryDrift.nextOccurrenceAfter(
        DateTime(2026, 9, 24),
        RecurringFrequency.weekly,
      );
      expect(next, DateTime(2026, 10, 1));
    });

    test('monthly advances by one calendar month', () {
      final next = RecurringRepositoryDrift.nextOccurrenceAfter(
        DateTime(2026, 1, 15),
        RecurringFrequency.monthly,
      );
      expect(next, DateTime(2026, 2, 15));
    });
  });
}
