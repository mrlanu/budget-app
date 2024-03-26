part of 'transaction_bloc.dart';

enum TransactionStatus { loading, success, failure }

class TransactionState extends Equatable {
  final Transaction? editedTransaction;
  final String? id;
  final TransactionType transactionType;
  final Amount amount;
  final DateTime? date;
  final Category? category;
  final Subcategory? subcategory;
  final Account? account;
  final String? description;

  final Budget budget;

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
      this.budget = const Budget(),
      this.trStatus = TransactionStatus.loading,
      this.status = FormzSubmissionStatus.initial,
      this.isValid = false,
      this.errorMessage});

  TransactionState copyWith({
    Transaction? editedTransaction,
    Amount? amount,
    DateTime? date,
    Category? Function()? category,
    Subcategory? Function()? subcategory,
    Account? account,
    String? description,
    Budget? budget,
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
      budget: budget ?? this.budget,
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
        subcategory,
        account,
        description,
        budget,
        status,
        isValid,
        errorMessage
      ];
}
