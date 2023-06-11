part of 'transfer_bloc.dart';

enum TransferStatus { loading, success, failure }

class TransferState extends Equatable {

  final String? id;
  final TransferStatus trStatus;
  final Amount amount;
  final DateTime? date;
  final List<Account> accounts;
  final List<Category> accountCategories;
  final Account? fromAccount;
  final Account? toAccount;
  final String notes;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  TransferState(
      {this.id,
        this.trStatus = TransferStatus.loading,
        this.amount = const Amount.pure(),
        this.date,
        this.accounts = const <Account>[],
        this.accountCategories = const <Category>[],
        this.fromAccount,
        this.toAccount,
        this.notes = '',
        this.status = FormzSubmissionStatus.initial,
        this.isValid = false,
        this.errorMessage});

  TransferState copyWith({
    String? id,
    TransferStatus? trStatus,
    Amount? amount,
    DateTime? date,
    List<Account>? accounts,
    List<Category>? accountCategories,
    Account? fromAccount,
    Account? toAccount,
    String? notes,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return TransferState(
      id: id ?? this.id,
      trStatus: trStatus ?? this.trStatus,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      accounts: accounts ?? this.accounts,
      accountCategories: accountCategories ?? this.accountCategories,
      fromAccount: fromAccount ?? this.fromAccount,
      toAccount: toAccount ?? this.toAccount,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    id,
    trStatus,
    amount,
    date,
    accounts,
    accountCategories,
    fromAccount,
    toAccount,
    notes,
    status,
    isValid,
    errorMessage
  ];
}
