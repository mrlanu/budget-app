part of 'account_edit_bloc.dart';

class AccountEditState extends Equatable {
  final String? name;
  final Amount balance;
  final List<Category> categories;
  final Category? category;
  final bool isIncludeInTotals;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  const AccountEditState({
    this.name,
    this.balance = const Amount.pure(),
    this.categories = const [],
    this.category,
    this.isIncludeInTotals = true,
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  AccountEditState copyWith({
    String? name,
    Amount? balance,
    List<Category>? categories,
    Category? category,
    bool? isIncludeInTotals,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return AccountEditState(
      name: name ?? this.name,
      balance: balance ?? this.balance,
      categories: categories ?? this.categories,
      category: category ?? this.category,
      isIncludeInTotals: isIncludeInTotals ?? this.isIncludeInTotals,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [name, balance, categories, category, isIncludeInTotals, status, isValid, errorMessage];
}
