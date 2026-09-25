part of 'debt_bloc.dart';

enum DebtStateStatus { loading, success, failure }

class DebtState extends Equatable {
  final DebtStateStatus status;
  final int? id;
  final String name;
  final double? startBalance;
  final MyDigit balance;
  final MyDigit minPayment;
  final MyDigit apr;
  final DateTime nextPaymentDue;
  final bool isValid;
  final FormzSubmissionStatus submissionStatus;
  final String? errorMessage;

  const DebtState({
    this.status = DebtStateStatus.loading,
    this.id,
    this.name = '',
    this.startBalance,
    this.balance = const MyDigit.pure(),
    this.minPayment = const MyDigit.pure(),
    this.apr = const MyDigit.pure(),
    required this.nextPaymentDue,
    this.isValid = false,
    this.submissionStatus = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  factory DebtState.initial() => DebtState(nextPaymentDue: DateTime.now());

  bool get isNameValid => name.trim().isNotEmpty;

  DebtState copyWith({
    DebtStateStatus? status,
    int? id,
    String? name,
    double? startBalance,
    MyDigit? balance,
    MyDigit? minPayment,
    MyDigit? apr,
    DateTime? nextPaymentDue,
    bool? isValid,
    FormzSubmissionStatus? submissionStatus,
    String? errorMessage,
  }) {
    return DebtState(
      status: status ?? this.status,
      id: id ?? this.id,
      name: name ?? this.name,
      startBalance: startBalance ?? this.startBalance,
      balance: balance ?? this.balance,
      minPayment: minPayment ?? this.minPayment,
      apr: apr ?? this.apr,
      nextPaymentDue: nextPaymentDue ?? this.nextPaymentDue,
      isValid: isValid ?? this.isValid,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        id,
        name,
        startBalance,
        balance,
        minPayment,
        apr,
        nextPaymentDue,
        submissionStatus,
        isValid,
        errorMessage,
      ];
}
