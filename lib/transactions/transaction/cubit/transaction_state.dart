part of 'transaction_cubit.dart';

class TransactionState extends Equatable {
  TransactionState({
    this.amount = const Amount.pure(),
    this.date,
    this.categories = const [],
    this.selectedCategory,
    this.subcategories = const [],
    this.selectedSubcategory,
    this.selectedAccount,
    this.notes = '',
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  final Amount amount;
  final DateTime? date;
  final List<Category> categories;
  final Category? selectedCategory;
  final List<Subcategory> subcategories;
  final Subcategory? selectedSubcategory;
  final AccountBrief? selectedAccount;
  final String notes;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        amount,
        date,
        categories,
        selectedCategory,
        subcategories,
        selectedSubcategory,
        selectedAccount,
        notes,
        status,
        isValid,
        errorMessage
      ];

  TransactionState copyWith({
    Amount? amount,
    DateTime? date,
    List<Category>? categories,
    Category? selectedCategory,
    List<Subcategory>? subcategories,
    Subcategory? selectedSubcategory,
    AccountBrief? selectedAccount,
    String? notes,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return TransactionState(
      amount: amount ?? this.amount,
      date: date ?? this.date,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      subcategories: subcategories ?? this.subcategories,
      selectedSubcategory: selectedSubcategory ?? this.selectedSubcategory,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  TransactionState copyWithResetSubcategory({
    Amount? amount,
    DateTime? date,
    List<Category>? categories,
    Category? selectedCategory,
    List<Subcategory>? subcategories,
    Subcategory? selectedSubcategory,
    AccountBrief? selectedAccount,
    String? notes,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return TransactionState(
      amount: amount ?? this.amount,
      date: date ?? this.date,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      subcategories: subcategories ?? this.subcategories,
      selectedSubcategory: selectedSubcategory,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
