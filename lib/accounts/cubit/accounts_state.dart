part of 'accounts_cubit.dart';

enum AccountsStatus { loading, success, failure }

class AccountsState extends Equatable {
  final AccountsStatus status;
  final List<Account> accountList;
  final List<Category> accountCategories;
  final AccountsViewFilter? filter;
  final String? errorMessage;

  const AccountsState(
      {this.status = AccountsStatus.loading,
      this.accountList = const [], this.filter,
        this.accountCategories = const [],
      this.errorMessage});

  List<Account> get filteredAccounts => filter!.applyAll(accountList);

  AccountsState copyWith({
    String? budgetId,
    AccountsStatus? status,
    List<Account>? accountList,
    List<Category>? accountCategories,
    AccountsViewFilter? filter,
    String? errorMessage,
  }) {
    return AccountsState(
      status: status ?? this.status,
      accountList: accountList ?? this.accountList,
      accountCategories: accountCategories ?? this.accountCategories,
      filter: filter ?? this.filter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, accountList, accountCategories, filter];
}
