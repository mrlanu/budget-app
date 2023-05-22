part of 'transaction_bloc.dart';

sealed class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

final class TransactionLoaded extends TransactionEvent {
  const TransactionLoaded();
}

final class TransactionEditRequested extends TransactionEvent {
  final Transaction transaction;
  const TransactionEditRequested({required this.transaction});
  @override
  List<Object?> get props => [transaction];
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
  final AccountBrief? account;
  const TransactionAccountChanged({this.account});
  @override
  List<Object?> get props => [account];
}

final class TransactionDateChanged extends TransactionEvent {
  final DateTime? dateTime;
  const TransactionDateChanged({this.dateTime});
  @override
  List<Object?> get props => [dateTime];
}

final class TransactionAmountChanged extends TransactionEvent {
  final String? amount;
  const TransactionAmountChanged({this.amount});
  @override
  List<Object?> get props => [amount];
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
