part of 'transaction_bloc.dart';

sealed class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

final class TransactionFormLoaded extends TransactionEvent {
  final Transaction? transaction;
  final TransactionType transactionType;
  const TransactionFormLoaded(
      {this.transaction, required this.transactionType,});
  @override
  List<Object?> get props => [transaction, transactionType,];
}

final class TransactionBudgetChanged extends TransactionEvent {
  final Budget budget;
  const TransactionBudgetChanged({required this.budget});
  @override
  List<Object?> get props => [budget];
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
  final Account? account;
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
