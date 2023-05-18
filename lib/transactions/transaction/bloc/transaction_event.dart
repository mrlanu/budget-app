part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
  @override
  List<Object?> get props => [];
}

class TransactionFormLoaded extends TransactionEvent {
  const TransactionFormLoaded();
}

class TransactionCategoryChanged extends TransactionEvent{
  final Category? category;
  const TransactionCategoryChanged({this.category});
  @override
  List<Object?> get props => [category];
}

class TransactionSubcategoryChanged extends TransactionEvent {
  final Subcategory? subcategory;
  const TransactionSubcategoryChanged({this.subcategory});
  @override
  List<Object?> get props => [subcategory];
}

class TransactionAccountChanged extends TransactionEvent {
  final AccountBrief? account;
  const TransactionAccountChanged({this.account});
  @override
  List<Object?> get props => [account];
}

class TransactionDateChanged extends TransactionEvent {
  final DateTime? dateTime;
  const TransactionDateChanged({this.dateTime});
  @override
  List<Object?> get props => [dateTime];
}

class TransactionAmountChanged extends TransactionEvent {
  final double? amount;
  const TransactionAmountChanged({this.amount});
  @override
  List<Object?> get props => [amount];
}

class TransactionNotesChanged extends TransactionEvent {
  final String? notes;
  const TransactionNotesChanged({this.notes});
  @override
  List<Object?> get props => [notes];
}

class TransactionFormSubmitted extends TransactionEvent {
  const TransactionFormSubmitted();
}
