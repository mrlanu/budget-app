part of 'transaction_cubit.dart';

class TransactionState extends Equatable {
  TransactionState({
    this.amount = 0.0,
    this.date,
    this.categories = const [],
    this.selectedCategory,
    this.subcategories = const [],
    this.selectedSubcategory,
    this.selectedAccount,
    this.notes = '',
    this.status = DataStatus.pure,
    this.errorMessage,
  });

  final double amount;
  final DateTime? date;
  final List<Category> categories;
  final Category? selectedCategory;
  final List<Subcategory> subcategories;
  final Subcategory? selectedSubcategory;
  final Category? selectedAccount;
  final String notes;
  final DataStatus status;
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
        errorMessage
      ];

  TransactionState copyWith({
    double? amount,
    DateTime? date,
    List<Category>? categories,
    Category? selectedCategory,
    List<Subcategory>? subcategories,
    Subcategory? selectedSubcategory,
    Category? selectedAccount,
    String? notes,
    DataStatus? status,
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
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  TransactionState copyWithResetSubcategory({
    double? amount,
    DateTime? date,
    List<Category>? categories,
    Category? selectedCategory,
    List<Subcategory>? subcategories,
    Subcategory? selectedSubcategory,
    Category? selectedAccount,
    String? notes,
    DataStatus? status,
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
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

}
