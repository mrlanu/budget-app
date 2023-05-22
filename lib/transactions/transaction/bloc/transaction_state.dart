part of 'transaction_bloc.dart';

enum TransactionStatus { loading, success, failure }

class TransactionState extends Equatable {
  final TransactionStatus trStatus;
  final Transaction? transaction;
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

  TransactionState._(
      {this.trStatus = TransactionStatus.loading,
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

  TransactionState.init() : this._();

  TransactionState.create({required Transaction emptyTransaction})
      : this._(transaction: emptyTransaction);

  TransactionState.edit(
      {required Transaction transaction,
      required double amount,
      required DateTime dateTime,
      required List<Category> categories,
      required Category category,
      required List<Subcategory> subcategories,
      required Subcategory subcategory,
      required List<AccountBrief> accounts,
      required AccountBrief? accountBrief,
      required String notes})
      : this._(
            trStatus: TransactionStatus.success,
            transaction: transaction,
            amount: Amount.dirty(amount.toString()),
            date: dateTime,
            categories: categories,
            category: category,
            subcategories: subcategories,
            subcategory: subcategory,
            accounts: accounts,
            account: accountBrief,
            description: notes);

  TransactionState.subcategoriesLoadInProgress(
      {required Transaction transaction,
      required List<Category> categories,
      required Amount amount,
      Category? category,
      DateTime? dateTime,
      required List<AccountBrief> accounts,
      AccountBrief? account,
      String? description,
      required FormzSubmissionStatus status,
      required bool isValid})
      : this._(
            trStatus: TransactionStatus.success,
            transaction: transaction,
            date: dateTime,
            categories: categories,
            amount: amount,
            category: category,
            accounts: accounts,
            account: account,
            description: description ?? '',
            isValid: isValid,
            status: status);

  TransactionState copyWith({
    TransactionStatus? trStatus,
    Transaction? transaction,
    TransactionType? transactionType,
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
    return TransactionState._(
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
