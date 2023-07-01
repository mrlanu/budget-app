part of 'debt_bloc.dart';

class DebtState extends Equatable {
  final String name;
  final MyDigit balance;
  final MyDigit minPayment;
  final MyDigit apr;
  final bool isValid;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  const DebtState(
      {this.name = 'No name',
      this.balance = const MyDigit.pure(),
      this.minPayment = const MyDigit.pure(),
      this.apr = const MyDigit.pure(),
      this.isValid = false,
      this.status = FormzSubmissionStatus.initial,
      this.errorMessage});

  DebtState copyWith({
    String? name,
    MyDigit? balance,
    MyDigit? minPayment,
    MyDigit? apr,
    bool? isValid,
    FormzSubmissionStatus? status,
    String? errorMessage,
  }) {
    return DebtState(
        name: name ?? this.name,
        balance: balance ?? this.balance,
        minPayment: minPayment ?? this.minPayment,
        apr: apr ?? this.apr,
        isValid: isValid ?? this.isValid,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object?> get props =>
      [name, balance, minPayment, apr, status, isValid, errorMessage];
}
