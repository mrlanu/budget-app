part of 'accounts_cubit.dart';

class AccountsState extends Equatable {
  final DataStatus status;
  final List<Account> accountList;
  final AccountsViewFilter filter;
  final String? errorMessage;

  const AccountsState(
      {this.status = DataStatus.loading,
      this.accountList = const [],
        required this.filter,
      this.errorMessage});

  List<Account> get filteredAccounts => filter.applyAll(accountList);

  AccountsState copyWith({
    String? budgetId,
    DataStatus? status,
    List<Account>? accountList,
    AccountsViewFilter? filter,
    String? errorMessage,
  }) {
    return AccountsState(
      status: status ?? this.status,
      accountList: accountList ?? this.accountList,
      filter: filter ?? this.filter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, accountList, filter];
}
