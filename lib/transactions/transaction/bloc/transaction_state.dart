part of 'transaction_bloc.dart';

enum TransactionStatus { loading, success, failure }

class TransactionState extends Equatable {
  final TransactionTile? editedTransaction;
  final String? id;
  final TransactionType transactionType;
  final Amount amount;
  final DateTime? date;
  final Category? category;
  final Subcategory? subcategory;
  final Account? account;
  final String? description;

  final List<Category> accountCategories;
  final List<Category> categories;
  final List<Subcategory> subcategories;
  final List<Account> accounts;

  final TransactionStatus trStatus;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  TransactionState(
      {this.editedTransaction,
      this.id,
      this.transactionType = TransactionType.EXPENSE,
      this.amount = const Amount.pure(),
      this.date,
      this.category,
      this.subcategory,
      this.account,
      this.description = '',
      this.accountCategories = const <Category>[],
      this.categories = const <Category>[],
      this.subcategories = const <Subcategory>[],
      this.accounts = const <Account>[],
      this.trStatus = TransactionStatus.loading,
      this.status = FormzSubmissionStatus.initial,
      this.isValid = false,
      this.errorMessage});

  TransactionState copyWith({
    TransactionTile? editedTransaction,
    Amount? amount,
    DateTime? date,
    Category? Function()? category,
    Subcategory? Function()? subcategory,
    Account? account,
    String? description,
    List<Category> Function()? accountCategories,
    List<Category> Function()? categories,
    List<Subcategory> Function()? subcategories,
    List<Account> Function()? accounts,
    TransactionStatus? trStatus,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return TransactionState(
      editedTransaction: editedTransaction ?? this.editedTransaction,
      id: this.id,
      transactionType: this.transactionType,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category != null ? category() : this.category,
      subcategory: subcategory != null ? subcategory() : this.subcategory,
      account: account ?? this.account,
      description: description ?? this.description,
      accountCategories: accountCategories != null
          ? accountCategories()
          : this.accountCategories,
      categories: categories != null ? categories() : this.categories,
      subcategories:
          subcategories != null ? subcategories() : this.subcategories,
      accounts: accounts != null ? accounts() : this.accounts,
      trStatus: trStatus ?? this.trStatus,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        editedTransaction,
        trStatus,
        amount,
        date,
        accountCategories,
        categories,
        category,
        subcategories,
        subcategory,
        accounts,
        account,
        description,
        status,
        isValid,
        errorMessage
      ];
}
