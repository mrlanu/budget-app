part of 'transfer_bloc.dart';

enum TransferStatus { loading, success, failure }

class TransferState extends Equatable {
  final ComprehensiveTransaction? editedTransfer;
  final int? id;
  final Amount amount;
  final DateTime? date;
  final Account? fromAccount;
  final Account? toAccount;
  final List<Account> accounts;
  final List<Category> categories;
  final String notes;
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
      this.accounts = const [],
      this.categories = const [],
      this.notes = '',
      this.trStatus = TransferStatus.loading,
      this.status = FormzSubmissionStatus.initial,
      this.isValid = false,
      this.errorMessage});

  TransferState copyWith({
    ComprehensiveTransaction? editedTransfer,
    int? id,
    Amount? amount,
    DateTime? date,
    Account? fromAccount,
    Account? toAccount,
    List<Account>? accounts,
    List<Category>? categories,
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
      fromAccount: fromAccount ?? this.fromAccount,
      toAccount: toAccount ?? this.toAccount,
      accounts: accounts ?? this.accounts,
      categories: categories ?? this.categories,
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
        toAccount,
        accounts,
        categories,
        notes,
        status,
        isValid,
        errorMessage
      ];
}
