part of 'transaction_bloc.dart';

class TransactionState extends Equatable {
  final Amount amount;
  final DateTime? date;
  final List<Category> categories;
  final Category? category;
  final List<Subcategory> subcategories;
  final Subcategory? subcategory;
  final AccountBrief? account;
  final String notes;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  const TransactionState._(
      {this.amount = const Amount.pure(),
      this.date,
      this.categories = const <Category>[],
      this.category,
      this.subcategories = const <Subcategory>[],
      this.subcategory,
      this.account,
      this.notes = '',
      this.status = FormzSubmissionStatus.initial,
      this.isValid = false,
      this.errorMessage});

  const TransactionState.initial() : this._();

  /*const TransactionState.categoriesLoadInProgress() : this._();*/

  /*const TransactionState.categoriesLoadSuccess(
      {required List<Category> categories})
      : this._(categories: categories);*/

  const TransactionState.subcategoriesLoadInProgress(
      {required List<Category> categories,
        required Amount amount,
      Category? category,
      DateTime? dateTime,
      AccountBrief? account,
      String? notes,
      required FormzSubmissionStatus status,
      required bool isValid})
      : this._(
            date: dateTime,
            categories: categories,
            amount: amount,
            category: category,
            account: account,
            notes: notes ?? '',
            isValid: isValid,
            status: status);

  TransactionState copyWith({
    Amount? amount,
    DateTime? date,
    List<Category>? categories,
    Category? category,
    List<Subcategory>? subcategories,
    Subcategory? subcategory,
    AccountBrief? account,
    String? notes,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return TransactionState._(
      amount: amount ?? this.amount,
      date: date ?? this.date,
      categories: categories ?? this.categories,
      category: category ?? this.category,
      subcategories: subcategories ?? this.subcategories,
      subcategory: subcategory ?? this.subcategory,
      account: account ?? this.account,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        amount,
        date,
        categories,
        category,
        subcategories,
        subcategory,
        account,
        notes,
        status,
        isValid,
        errorMessage
      ];
}
