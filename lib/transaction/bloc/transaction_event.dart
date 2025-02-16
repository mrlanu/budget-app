part of 'transaction_bloc.dart';

sealed class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

final class TransactionFormLoaded extends TransactionEvent {
  final int? transactionId;

  const TransactionFormLoaded({this.transactionId});

  @override
  List<Object?> get props => [transactionId];
}

final class TransactionCategoriesChanged extends TransactionEvent {
  final List<Category> categories;

  const TransactionCategoriesChanged({required this.categories});

  @override
  List<Object?> get props => [categories];
}

final class TransactionSubcategoriesChanged extends TransactionEvent {
  final List<Subcategory> subcategories;

  const TransactionSubcategoriesChanged({required this.subcategories});

  @override
  List<Object?> get props => [subcategories];
}

final class TransactionAccountsChanged extends TransactionEvent {
  final List<AccountWithDetails> accounts;

  const TransactionAccountsChanged({required this.accounts});

  @override
  List<Object?> get props => [accounts];
}

final class TransactionAmountChanged extends TransactionEvent {
  final String? amount;

  const TransactionAmountChanged({this.amount});

  @override
  List<Object?> get props => [amount];
}

final class TransactionDateChanged extends TransactionEvent {
  final DateTime? dateTime;

  const TransactionDateChanged({this.dateTime});

  @override
  List<Object?> get props => [dateTime];
}

final class TransactionCategoryChanged extends TransactionEvent {
  final Category? category;

  const TransactionCategoryChanged({this.category});

  @override
  List<Object?> get props => [category];
}

final class TransactionSubcategoryChanged extends TransactionEvent {
  final Subcategory? subcategory;

  const TransactionSubcategoryChanged({this.subcategory});

  @override
  List<Object?> get props => [subcategory];
}

final class TransactionAccountChanged extends TransactionEvent {
  final AccountWithDetails? account;

  const TransactionAccountChanged({this.account});

  @override
  List<Object?> get props => [account];
}

final class TransactionNotesChanged extends TransactionEvent {
  final String? description;

  const TransactionNotesChanged({this.description});

  @override
  List<Object?> get props => [description];
}

final class TransactionFormSubmitted extends TransactionEvent {
  final BuildContext? context;

  const TransactionFormSubmitted({this.context});
}
