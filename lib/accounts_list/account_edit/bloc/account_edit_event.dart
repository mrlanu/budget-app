part of 'account_edit_bloc.dart';

sealed class AccountEditEvent extends Equatable {
  const AccountEditEvent();
}

final class AccountEditFormLoaded extends AccountEditEvent {
  final Account? account;
  AccountEditFormLoaded({this.account});
  @override
  List<Object?> get props => [account];
}

final class AccountNameChanged extends AccountEditEvent {
  final String name;

  AccountNameChanged({required this.name});

  @override
  List<Object?> get props => [name];
}

final class AccountBalanceChanged extends AccountEditEvent {
  final String? balance;

  AccountBalanceChanged({this.balance});

  @override
  List<Object?> get props => [balance];
}

final class AccountBudgetChanged extends AccountEditEvent {
  final Budget budget;
  const AccountBudgetChanged({required this.budget});
  @override
  List<Object?> get props => [budget];
}

final class AccountCategoryChanged extends AccountEditEvent {
  final Category? category;
  const AccountCategoryChanged({this.category});
  @override
  List<Object?> get props => [category];
}

final class AccountIncludeInTotalsChanged extends AccountEditEvent {
  final bool value;
  const AccountIncludeInTotalsChanged({required this.value});
  @override
  List<Object?> get props => [value];
}

final class AccountFormSubmitted extends AccountEditEvent {
  const AccountFormSubmitted();
  @override
  List<Object?> get props => [];
}
