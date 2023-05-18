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
      this.errorMessage});

  const TransactionState.initial() : this._();

  const TransactionState.categoriesLoadInProgress() : this._();

  const TransactionState.categoriesLoadSuccess(
      {required List<Category> categories})
      : this._(categories: categories);

  const TransactionState.subcategoriesLoadInProgress(
      {required List<Category> categories, Category? category})
      : this._(categories: categories, category: category);

  const TransactionState.subcategoriesLoadSuccess(
      {required List<Category> categories,
      required Category? category,
      required List<Subcategory> subcategories})
      : this._(
            categories: categories,
            category: category,
            subcategories: subcategories);

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
    errorMessage
  ];
}
