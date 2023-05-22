part of 'transaction_bloc.dart';

enum TransactionStatus { loading, success, failure }

class TransactionState extends Equatable {
  final bool isEdit;
  final TransactionStatus trStatus;
  final Transaction? transaction;
  final TransactionType transactionType;
  final Amount amount;
  final DateTime? date;
  final List<Category> categories;
  final Category? category;
  final List<Subcategory> subcategories;
  final Subcategory? subcategory;
  final List<AccountBrief> accounts;
  final AccountBrief? account;
  final String description;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  TransactionState(
      {this.transactionType = TransactionType.EXPENSE,
      this.isEdit = false,
      this.trStatus = TransactionStatus.loading,
      this.transaction,
      this.amount = const Amount.pure(),
      this.date,
      this.categories = const <Category>[],
      this.category,
      this.subcategories = const <Subcategory>[],
      this.subcategory,
      this.accounts = const <AccountBrief>[],
      this.account,
      this.description = '',
      this.status = FormzSubmissionStatus.initial,
      this.isValid = false,
      this.errorMessage});

  TransactionState resetSubcategories() {
    return TransactionState(
        transactionType: this.transactionType,
        isEdit: this.isEdit,
        trStatus: this.trStatus,
        transaction: this.transaction,
        date: this.date,
        categories: this.categories,
        category: this.category,
        subcategories: <Subcategory>[],
        subcategory: null,
        amount: this.amount,
        accounts: this.accounts,
        account: this.account,
        description: this.description,
        isValid: this.isValid,
        status: this.status);
  }

  TransactionState copyWith({
    bool? isEdit,
    TransactionStatus? trStatus,
    Transaction? transaction,
    Amount? amount,
    DateTime? date,
    List<Category>? categories,
    Category? category,
    List<Subcategory>? subcategories,
    Subcategory? subcategory,
    List<AccountBrief>? accounts,
    AccountBrief? account,
    String? description,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return TransactionState(
      transactionType: transactionType ?? this.transactionType,
      isEdit: isEdit ?? this.isEdit,
      trStatus: trStatus ?? this.trStatus,
      transaction: transaction ?? this.transaction,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      categories: categories ?? this.categories,
      category: category ?? this.category,
      subcategories: subcategories ?? this.subcategories,
      subcategory: subcategory ?? this.subcategory,
      accounts: accounts ?? this.accounts,
      account: account ?? this.account,
      description: description ?? this.description,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isEdit,
        trStatus,
        transaction,
        amount,
        date,
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
