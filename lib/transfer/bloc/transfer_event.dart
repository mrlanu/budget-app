part of 'transfer_bloc.dart';

sealed class TransferEvent extends Equatable {
  const TransferEvent();

  @override
  List<Object?> get props => [];
}

final class TransferFormLoaded extends TransferEvent {
  final TransactionTile? transactionTile;
  const TransferFormLoaded({this.transactionTile});

  @override
  List<Object?> get props => [transactionTile];
}

final class TransferAmountChanged extends TransferEvent {
  final String? amount;
  const TransferAmountChanged({this.amount});
  @override
  List<Object?> get props => [amount];
}

final class TransferDateChanged extends TransferEvent {
  final DateTime? dateTime;
  const TransferDateChanged({this.dateTime});
  @override
  List<Object?> get props => [dateTime];
}

final class TransferAccountsChanged extends TransferEvent {
  final List<Account> accounts;
  const TransferAccountsChanged({required this.accounts});
  @override
  List<Object?> get props => [accounts];
}

final class TransferFromAccountChanged extends TransferEvent {
  final Account? account;
  const TransferFromAccountChanged({this.account});
  @override
  List<Object?> get props => [account];
}

final class TransferToAccountChanged extends TransferEvent {
  final Account? account;
  const TransferToAccountChanged({this.account});
  @override
  List<Object?> get props => [account];
}

final class TransferNotesChanged extends TransferEvent {
  final String? notes;
  const TransferNotesChanged({this.notes});
  @override
  List<Object?> get props => [notes];
}

final class TransferCategoriesChanged extends TransferEvent {
  final List<Category> categories;
  const TransferCategoriesChanged({required this.categories});
  @override
  List<Object?> get props => [categories];
}

final class TransferFormSubmitted extends TransferEvent {
  final BuildContext? context;
  const TransferFormSubmitted({this.context});
}
