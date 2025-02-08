import 'package:budget_app/database/tables.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../transaction/models/transaction_type.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Accounts, Categories, Subcategories, Transactions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      beforeOpen: (details) async {
        if (false) {
          final m = Migrator(this);
          for (final table in allTables) {
            await m.deleteTable(table.actualTableName);
            await m.createTable(table);
          }
        }
      },
      onUpgrade: (Migrator m, int from, int to) async {
        /*if (from < 2) {
          // we added the dueDate property in the change from version 1 to
          // version 2
          await m.addColumn(todos, todos.dueDate);
        }
        if (from < 3) {
          // we added the priority property in the change from version 1 or 2
          // to version 3
          await m.addColumn(todos, todos.priority);
        }*/
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'my_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
