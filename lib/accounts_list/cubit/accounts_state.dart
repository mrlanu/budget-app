part of 'accounts_cubit.dart';

enum AccountsStatus { loading, success, failure }

class AccountsState extends Equatable {
  final AccountsStatus status;
  final List<Account> accountList;
  final List<Category> accountCategories;
  final String? errorMessage;

  const AccountsState(
      {this.status = AccountsStatus.loading,
      this.accountList = const [],
      this.accountCategories = const [],
      this.errorMessage});

  AccountsState copyWith({
    String? budgetId,
    AccountsStatus? status,
    List<Account>? accountList,
    List<Category>? accountCategories,
    String? errorMessage,
  }) {
    return AccountsState(
      status: status ?? this.status,
      accountList: accountList ?? this.accountList,
      accountCategories: accountCategories ?? this.accountCategories,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, accountList, accountCategories];
}
