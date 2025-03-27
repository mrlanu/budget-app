import 'dart:io';

import 'package:drift/native.dart';
import '../database/database.dart';

class BackupImporterService {
  final AppDatabase liveDb;

  BackupImporterService(this.liveDb);

  Future<void> importBackupFromFile(File backupFile) async {
    final tempDb = _openTemporaryDb(backupFile);

    await liveDb.transaction(() async {
      await _clearAllTables(liveDb);
      await _copyAllTables(from: tempDb, to: liveDb);
    });

    await tempDb.close();
  }

  /// Creates a temporary AppDatabase from a backup file
  AppDatabase _openTemporaryDb(File file) {
    return AppDatabase(NativeDatabase(file));
  }

  /// Clears all rows from every table in the live DB
  Future<void> _clearAllTables(AppDatabase db) async {
    await db.delete(db.categories).go();
    await db.delete(db.subcategories).go();
    await db.delete(db.accounts).go();
    await db.delete(db.transactions).go();
    await db.delete(db.debts).go();
    await db.delete(db.payments).go();
  }

  /// Copies all data from temp DB into live DB
  Future<void> _copyAllTables({
    required AppDatabase from,
    required AppDatabase to,
  }) async {
    final categories = await from.select(from.categories).get();
    for (final row in categories) {
      await to.into(to.categories).insertOnConflictUpdate(row);
    }

    final subcategories = await from.select(from.subcategories).get();
    for (final row in subcategories) {
      await to.into(to.subcategories).insertOnConflictUpdate(row);
    }

    final accounts = await from.select(from.accounts).get();
    for (final row in accounts) {
      await to.into(to.accounts).insertOnConflictUpdate(row);
    }

    final transactions = await from.select(from.transactions).get();
    for (final row in transactions) {
      await to.into(to.transactions).insertOnConflictUpdate(row);
    }

    final debts = await from.select(from.debts).get();
    for (final row in debts) {
      await to.into(to.debts).insertOnConflictUpdate(row);
    }

    final payments = await from.select(from.payments).get();
    for (final row in payments) {
      await to.into(to.payments).insertOnConflictUpdate(row);
    }
  }
}
