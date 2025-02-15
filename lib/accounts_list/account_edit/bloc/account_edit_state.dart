part of 'account_edit_bloc.dart';

enum AccountEditStatus { loading, success, failure }

class AccountEditState extends Equatable {
  final int? id;
  final String? name;
  final Amount balance;
  final Category? category;
  final List<Category> categories;
  final bool isIncludeInTotals;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;
  final AccountEditStatus accStatus;

  const AccountEditState({
    this.id,
    this.name,
    this.balance = const Amount.pure(),
    this.category,
    this.categories = const [],
    this.isIncludeInTotals = true,
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
    this.accStatus = AccountEditStatus.loading,
  });

  AccountEditState copyWith({
    int? id,
    List<AccountWithDetails>? accounts,
    String? name,
    Amount? balance,
    Category? category,
    List<Category>? categories,
    bool? isIncludeInTotals,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
    AccountEditStatus? accStatus,
  }) {
    return AccountEditState(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      category: category ?? this.category,
      categories: categories ?? this.categories,
      isIncludeInTotals: isIncludeInTotals ?? this.isIncludeInTotals,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
      accStatus: accStatus ?? this.accStatus,
    );
  }

  @override
  List<Object?> get props => [
        balance,
        id,
        name,
        category,
        categories,
        isIncludeInTotals,
        status,
        isValid,
        errorMessage,
        accStatus
      ];
}
