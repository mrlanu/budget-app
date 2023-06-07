part of 'accounts_list_cubit.dart';

enum AccountsListStatus { loading, success, failure }

class AccountsListState extends Equatable {
  final AccountsListStatus status;
  final List<Account> accounts;
  final List<Category> accountCategories;
  final String? errorMessage;

  const AccountsListState({
    this.status = AccountsListStatus.loading,
    this.accounts = const [],
    required this.accountCategories,
    this.errorMessage,
  });

  AccountsListState copyWith({
    AccountsListStatus? status,
    List<Account>? accounts,
    Account? editedAccount,
    List<Category>? accountCategories,
    String? errorMessage,
  }) {
    return AccountsListState(
        status: status ?? this.status,
        accounts: accounts ?? this.accounts,
        accountCategories: accountCategories ?? this.accountCategories,
        errorMessage: errorMessage ?? errorMessage);
  }

  @override
  List<Object?> get props =>
      [status, accounts, accountCategories, errorMessage];
}
