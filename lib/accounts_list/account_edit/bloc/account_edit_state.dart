part of 'account_edit_bloc.dart';

enum AccountEditStatus { loading, success, failure }

class AccountEditState extends Equatable {
  final String? id;
  final String? name;
  final Amount balance;
  final List<Category> categories;
  final Category? category;
  final bool isIncludeInTotals;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;
  final AccountEditStatus accStatus;

  const AccountEditState({
    this.id,
    this.name,
    this.balance = const Amount.pure(),
    this.categories = const [],
    this.category,
    this.isIncludeInTotals = true,
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
    this.accStatus = AccountEditStatus.loading,
  });

  AccountEditState copyWith({
    String? id,
    String? name,
    Amount? balance,
    List<Category>? categories,
    Category? category,
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
      categories: categories ?? this.categories,
      category: category ?? this.category,
      isIncludeInTotals: isIncludeInTotals ?? this.isIncludeInTotals,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
      accStatus: accStatus ?? this.accStatus,
    );
  }

  @override
  List<Object?> get props => [
        balance,
        categories,
        id,
        name,
        category,
        isIncludeInTotals,
        status,
        isValid,
        errorMessage,
        accStatus
      ];
}
