part of 'accounts_list_cubit.dart';

enum AccountsListStatus { loading, success, failure }

class AccountsListState extends Equatable {
  final AccountsListStatus status;
  final List<Account> accounts;
  final Account? editedAccount;
  final List<Category> accountCategories;

  const AccountsListState({
    this.status = AccountsListStatus.loading,
    this.accounts = const [],
    this.editedAccount,
    required this.accountCategories,
  });

  AccountsListState copyWith(
      {AccountsListStatus? status,
      List<Account>? accounts,
      Account? editedAccount,
      List<Category>? accountCategories}) {
    return AccountsListState(
        status: status ?? this.status,
        accounts: accounts ?? this.accounts,
        editedAccount: editedAccount ?? this.editedAccount,
        accountCategories: accountCategories ?? this.accountCategories);
  }

  /*AccountsListState resetAccount() {
    return AccountsListState(
      status: this.status,
      accounts: this.accounts,
      editedAccount: null,
    );
  }*/

  @override
  List<Object?> get props => [status, accounts, editedAccount, accountCategories];
}
