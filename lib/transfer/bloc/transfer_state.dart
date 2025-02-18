part of 'transfer_bloc.dart';

enum TransferStatus { loading, success, failure }

class TransferState extends Equatable {
  final TransactionWithDetails? editedTransfer;
  final int? id;
  final Amount amount;
  final DateTime? date;
  final AccountWithDetails? fromAccount;
  final AccountWithDetails? toAccount;
  final String notes;
  final List<AccountWithDetails> accounts;
  final TransferStatus trStatus;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  TransferState(
      {this.editedTransfer,
      this.id,
      this.amount = const Amount.pure(),
      this.date,
      this.fromAccount,
      this.toAccount,
      this.notes = '',
      this.accounts = const [],
      this.trStatus = TransferStatus.loading,
      this.status = FormzSubmissionStatus.initial,
      this.isValid = false,
      this.errorMessage});

  TransferState copyWith({
    TransactionWithDetails? editedTransfer,
    int? id,
    Amount? amount,
    DateTime? date,
    AccountWithDetails? fromAccount,
    AccountWithDetails? toAccount,
    String? notes,
    List<AccountWithDetails>? accounts,
    TransferStatus? trStatus,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return TransferState(
      editedTransfer: editedTransfer ?? this.editedTransfer,
      id: id ?? this.id,
      trStatus: trStatus ?? this.trStatus,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      fromAccount: fromAccount ?? this.fromAccount,
      toAccount: toAccount ?? this.toAccount,
      notes: notes ?? this.notes,
      accounts: accounts ?? this.accounts,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        editedTransfer,
        id,
        trStatus,
        amount,
        date,
        fromAccount,
        toAccount,
        notes,
        accounts,
        status,
        isValid,
        errorMessage
      ];
}
