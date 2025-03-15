part of 'transaction_bloc.dart';

enum TransactionStatus { loading, success, failure }

class TransactionState extends Equatable {
  final TransactionWithDetails? editedTransaction;
  final int? id;
  final TransactionType transactionType;
  final Amount amount;
  final DateTime? date;
  final Category? category;
  final Subcategory? subcategory;
  final AccountWithDetails? account;
  final String? description;
  final List<AccountWithDetails> accounts;
  final List<Category> categories;
  final List<Subcategory> subcategories;

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
      this.categories = const [],
      this.subcategories = const [],
      this.accounts = const [],
      this.subcategory,
      this.account,
      this.description = '',
      this.trStatus = TransactionStatus.loading,
      this.status = FormzSubmissionStatus.initial,
      this.isValid = false,
      this.errorMessage});

  TransactionState copyWith({
    TransactionWithDetails? editedTransaction,
    int? id,
    TransactionType? transactionType,
    Amount? amount,
    DateTime? date,
    Category? Function()? category,
    List<Category>? categories,
    List<Subcategory>? subcategories,
    List<AccountWithDetails>? accounts,
    Subcategory? Function()? subcategory,
    AccountWithDetails? account,
    String? description,
    TransactionStatus? trStatus,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return TransactionState(
      editedTransaction: editedTransaction ?? this.editedTransaction,
      id: id ?? this.id,
      transactionType: transactionType ?? this.transactionType,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category != null ? category() : this.category,
      categories: categories ?? this.categories,
      subcategories: subcategories ?? this.subcategories,
      accounts: accounts ?? this.accounts,
      subcategory: subcategory != null ? subcategory() : this.subcategory,
      account: account ?? this.account,
      description: description ?? this.description,
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
        category,
        categories,
        subcategories,
        accounts,
        subcategory,
        account,
        description,
        status,
        isValid,
        errorMessage
      ];
}
