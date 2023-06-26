part of 'accounts_cubit.dart';

class AccountsState extends Equatable {
  final String categoryId;
  final DataStatus status;
  final List<Account> accountList;
  final String? errorMessage;

  const AccountsState(
      {required this.categoryId, this.status = DataStatus.loading,
      this.accountList = const [],
      this.errorMessage});

  AccountsState copyWith({
    String? budgetId,
    String? categoryId,
    DataStatus? status,
    List<Account>? accountList,
    String? errorMessage,
  }) {
    return AccountsState(
      categoryId: categoryId ?? this.categoryId,
      status: status ?? this.status,
      accountList: accountList ?? this.accountList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [categoryId, status, accountList];
}
