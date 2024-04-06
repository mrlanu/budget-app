part of 'transfer_bloc.dart';

enum TransferStatus { loading, success, failure }

class TransferState extends Equatable {
  final ComprehensiveTransaction? editedTransfer;
  final String? id;
  final Amount amount;
  final DateTime? date;
  final Account? fromAccount;
  final Account? toAccount;
  final String notes;
  final TransferStatus trStatus;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;
  final Budget budget;

  TransferState(
      {this.editedTransfer,
      this.id,
      this.amount = const Amount.pure(),
      this.date,
      this.fromAccount,
      this.toAccount,
      this.notes = '',
      this.budget = const Budget(),
      this.trStatus = TransferStatus.loading,
      this.status = FormzSubmissionStatus.initial,
      this.isValid = false,
      this.errorMessage});

  TransferState copyWith({
    ComprehensiveTransaction? editedTransfer,
    String? id,
    Amount? amount,
    DateTime? date,
    Account? fromAccount,
    Account? toAccount,
    Budget? budget,
    String? notes,
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
      budget: budget ?? this.budget,
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
        editedTransfer,
        id,
        trStatus,
        amount,
        date,
        fromAccount,
        budget,
        toAccount,
        notes,
        status,
        isValid,
        errorMessage
      ];
}
