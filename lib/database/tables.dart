import 'package:drift/drift.dart';

import '../transaction/models/transaction_type.dart';

// Categories Table
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  IntColumn get iconCode => integer()();
  TextColumn get type => text().map(const TransactionTypeConverter())();
}

// Subcategories Table
class Subcategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  IntColumn get categoryId => integer().references(Categories, #id)();
}

// Accounts Table
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  RealColumn get balance => real()();
  RealColumn get initialBalance => real()();
  TextColumn get currency => text().nullable().withLength(min: 1, max: 50)();
  IntColumn get categoryId => integer().references(Categories, #id)();
  BoolColumn get includeInTotal => boolean()();
}

// Transactions Table
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  IntColumn get subcategoryId => integer().references(Subcategories, #id)();
  @ReferenceName('fromAccount')
  IntColumn get fromAccountId => integer().references(Accounts, #id)();
  @ReferenceName('toAccount')
  IntColumn get toAccountId => integer().nullable().references(Accounts, #id)();
  TextColumn get description => text()();
  TextColumn get type => text().map(const TransactionTypeConverter())();
}

// Converts TransactionType to a String (e.g., "income") for storage
class TransactionTypeConverter extends TypeConverter<TransactionType, String> {
  const TransactionTypeConverter();

  @override
  TransactionType fromSql(String fromDb) {
    return TransactionType.values.firstWhere((e) => e.name == fromDb);
  }

  @override
  String toSql(TransactionType value) {
    return value.name;
  }
}
