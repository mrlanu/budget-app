import 'package:budget_app/accounts_list/account_edit/model/account_with_details.dart';
import 'package:budget_app/database/tables.dart';
import 'package:budget_app/database/transaction_with_detail.dart';
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

  Stream<List<Category>> watchAllCategories() {
    return select(categories).watch();
  }

  Stream<List<Subcategory>> watchAllSubcategories() {
    return select(subcategories).watch();
  }

  Future<int> insertCategory(CategoriesCompanion categoryCompanion) async {
    return await into(categories).insert(categoryCompanion);
  }

  Future<bool> updateCategory(Category category) async {
    return update(categories).replace(category);
  }

  Future<int> deleteCategory(int id) async {
    return await (delete(categories)..where((c) => c.id.equals(id))).go();
  }

  Future<Category> categoryById(int id) {
    return (select(categories)..where((c) => c.id.equals(id))).getSingle();
  }

  Future<List<Category>> getAllCategories() async {
    return await select(categories).get();
  }

  Stream<List<Account>> watchAllAccounts() {
    return select(accounts).watch();
  }

  Future<int> insertAccount(AccountsCompanion accountsCompanion) async {
    return await into(accounts).insert(accountsCompanion);
  }

  Future<bool> updateAccount(Account acc) async {
    return update(accounts).replace(acc);
  }

  Future<int> deleteAccount(int id) async {
    return await (delete(accounts)..where((c) => c.id.equals(id))).go();
  }

  Future<Account> accountById(int id) {
    return (select(accounts)..where((a) => a.id.equals(id))).getSingle();
  }

  Future<List<Account>> getAllAccounts() async {
    return await select(accounts).get();
  }

  Stream<List<AccountWithDetails>> watchAccountsWithDetails() {
    // Build the query with joins
    final query = select(accounts).join([
      innerJoin(categories, accounts.categoryId.equalsExp(categories.id)),
    ]);

    // Execute the query and map the results
    return query.map((row) {
      final r = row.readTable(accounts);
      return AccountWithDetails(
          balance: r.balance,
          initialBalance: r.initialBalance,
          name: r.name,
          currency: r.currency ?? 'USD',
          id: r.id,
          includeInTotal: r.includeInTotal,
          category: row.readTable(categories));
    }).watch();
  }

  Future<List<TransactionWithDetails>> getTransactionsForCertainMonth(
      DateTime date) async {
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);

    // Build the query with joins
    final query = select(transactions).join([
      innerJoin(categories, transactions.categoryId.equalsExp(categories.id)),
      innerJoin(subcategories,
          transactions.subcategoryId.equalsExp(subcategories.id)),
      innerJoin(accounts, transactions.fromAccountId.equalsExp(accounts.id)),
      leftOuterJoin(accounts, transactions.toAccountId.equalsExp(accounts.id))
    ])
      ..where(
          transactions.date.isBetweenValues(firstDayOfMonth, lastDayOfMonth))
      ..orderBy([OrderingTerm.desc(transactions.date)]);

    // Execute the query and map the results
    return await query.map((row) {
      return TransactionWithDetails(
          transaction: row.readTable(transactions),
          category: row.readTable(categories),
          subcategory: row.readTable(subcategories),
          fromAccount: row.readTable(accounts),
          toAccount: row.readTableOrNull(accounts));
    }).get();
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
