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

    test('weekly keeps weekday across fall DST transition', () {
      // US DST ended 2024-11-03. Duration(days: 7) from local midnight
      // would land on Thu 23:00; calendar arithmetic must stay Friday.
      final friday = DateTime(2024, 11, 1);
      expect(friday.weekday, DateTime.friday);

      final next = RecurringRepositoryDrift.nextOccurrenceAfter(
        friday,
        RecurringFrequency.weekly,
      );
      expect(next, DateTime(2024, 11, 8));
      expect(next.weekday, DateTime.friday);
    });

    test('weekly keeps weekday across several weeks including DST', () {
      var date = DateTime(2024, 11, 1); // Friday
      for (var i = 0; i < 8; i++) {
        date = RecurringRepositoryDrift.nextOccurrenceAfter(
          date,
          RecurringFrequency.weekly,
        );
        expect(date.weekday, DateTime.friday, reason: 'week ${i + 1}');
      }
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
