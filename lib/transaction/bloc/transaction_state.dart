part of 'transaction_bloc.dart';

enum TransactionStatus { loading, success, failure }

class TransactionState extends Equatable {
  final ComprehensiveTransaction? editedTransaction;
  final int? id;
  final TransactionType transactionType;
  final Amount amount;
  final DateTime? date;
  final Category? category;
  final List<Category> categories;
  final Subcategory? subcategory;
  final List<Subcategory> subcategories;
  final Account? account;
  final List<Account> accounts;
  final String? description;

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
      this.subcategory,
      this.subcategories = const [],
      this.account,
      this.accounts = const [],
      this.description = '',
      this.trStatus = TransactionStatus.loading,
      this.status = FormzSubmissionStatus.initial,
      this.isValid = false,
      this.errorMessage});

  TransactionState copyWith({
    ComprehensiveTransaction? editedTransaction,
    int? id,
    TransactionType? transactionType,
    Amount? amount,
    DateTime? date,
    Category? Function()? category,
    List<Category>? categories,
    Subcategory? Function()? subcategory,
    List<Subcategory>? subcategories,
    Account? account,
    List<Account>? accounts,
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
      subcategory: subcategory != null ? subcategory() : this.subcategory,
      subcategories: subcategories ?? this.subcategories,
      account: account ?? this.account,
      accounts: accounts ?? this.accounts,
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
        subcategory,
        subcategories,
        account,
        accounts,
        description,
        status,
        isValid,
        errorMessage
      ];
}
