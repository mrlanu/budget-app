part of 'transaction_bloc.dart';

class TransactionState extends Equatable {
  final bool isNewTransaction;
  final String? transactionId;
  final TransactionType transactionType;
  final Amount amount;
  final DateTime? date;
  final List<Category> categories;
  final Category? category;
  final List<Subcategory> subcategories;
  final Subcategory? subcategory;
  final List<AccountBrief> accounts;
  final AccountBrief? account;
  final String notes;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  TransactionState._(
      {this.isNewTransaction = true,
      this.transactionId,
      this.transactionType = TransactionType.EXPENSE,
      this.amount = const Amount.pure(),
      this.date,
      this.categories = const <Category>[],
      this.category,
      this.subcategories = const <Subcategory>[],
      this.subcategory,
      this.accounts = const <AccountBrief>[],
      this.account,
      this.notes = '',
      this.status = FormzSubmissionStatus.initial,
      this.isValid = false,
      this.errorMessage});

  TransactionState.initial() : this._();

  TransactionState.loading() : this._(isNewTransaction: false);

  TransactionState.edit(
      {required String? transactionId,
      required String amount,
      required DateTime dateTime,
      required List<Category> categories,
      required Category category,
      required List<Subcategory> subcategories,
      required Subcategory subcategory,
      required List<AccountBrief> accounts,
      required AccountBrief? accountBrief,
      required String notes})
      : this._(
            transactionId: transactionId,
            isNewTransaction: true,
            amount: Amount.dirty(amount),
            date: dateTime,
            categories: categories,
            category: category,
            subcategories: subcategories,
            subcategory: subcategory,
            accounts: accounts,
            account: accountBrief,
            notes: notes);

  TransactionState.subcategoriesLoadInProgress(
      {required String? transactionId,
      required List<Category> categories,
      required Amount amount,
      Category? category,
      DateTime? dateTime,
      required List<AccountBrief> accounts,
      AccountBrief? account,
      String? notes,
      required FormzSubmissionStatus status,
      required bool isValid})
      : this._(
            transactionId: transactionId,
            date: dateTime,
            categories: categories,
            amount: amount,
            category: category,
            accounts: accounts,
            account: account,
            notes: notes ?? '',
            isValid: isValid,
            status: status);

  TransactionState copyWith({
    String? transactionId,
    TransactionType? transactionType,
    Amount? amount,
    DateTime? date,
    List<Category>? categories,
    Category? category,
    List<Subcategory>? subcategories,
    Subcategory? subcategory,
    List<AccountBrief>? accounts,
    AccountBrief? account,
    String? notes,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return TransactionState._(
      transactionId: transactionId ?? this.transactionId,
      transactionType: transactionType ?? this.transactionType,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      categories: categories ?? this.categories,
      category: category ?? this.category,
      subcategories: subcategories ?? this.subcategories,
      subcategory: subcategory ?? this.subcategory,
      accounts: accounts ?? this.accounts,
      account: account ?? this.account,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        transactionId,
        isNewTransaction,
        amount,
        date,
        categories,
        category,
        subcategories,
        subcategory,
        accounts,
        account,
        notes,
        status,
        isValid,
        errorMessage
      ];
}
