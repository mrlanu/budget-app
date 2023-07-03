part of 'debt_bloc.dart';

enum DebtStateStatus { loading, success, failure }

class DebtState extends Equatable {
  final DebtStateStatus status;
  final String? id;
  final String name;
  final MyDigit balance;
  final MyDigit minPayment;
  final MyDigit apr;
  final bool isValid;
  final FormzSubmissionStatus submissionStatus;
  final String? errorMessage;

  const DebtState(
      {this.status = DebtStateStatus.loading,
      this.id,
      this.name = 'No name',
      this.balance = const MyDigit.pure(),
      this.minPayment = const MyDigit.pure(),
      this.apr = const MyDigit.pure(),
      this.isValid = false,
      this.submissionStatus = FormzSubmissionStatus.initial,
      this.errorMessage});

  DebtState copyWith({
    DebtStateStatus? status,
    String? id,
    String? name,
    MyDigit? balance,
    MyDigit? minPayment,
    MyDigit? apr,
    bool? isValid,
    FormzSubmissionStatus? submissionStatus,
    String? errorMessage,
  }) {
    return DebtState(
        status: status ?? this.status,
        id: id ?? this.id,
        name: name ?? this.name,
        balance: balance ?? this.balance,
        minPayment: minPayment ?? this.minPayment,
        apr: apr ?? this.apr,
        isValid: isValid ?? this.isValid,
        submissionStatus: submissionStatus ?? this.submissionStatus,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object?> get props => [
        status,
        id,
        name,
        balance,
        minPayment,
        apr,
        submissionStatus,
        isValid,
        errorMessage
      ];
}
