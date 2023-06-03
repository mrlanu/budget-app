part of 'accounts_cubit.dart';

class AccountsState extends Equatable {
  final DataStatus status;
  final List<Account> accountList;
  final String? errorMessage;

  const AccountsState(
      {this.status = DataStatus.loading, this.accountList = const [], this.errorMessage});

  AccountsState copyWith({
    DataStatus? status,
    List<Account>? accountList,
    String? errorMessage,
  }) {
    return AccountsState(
      status: status ?? this.status,
      accountList: accountList ?? this.accountList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, accountList];
}
