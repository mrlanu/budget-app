part of 'debt_payoff_cubit.dart';

enum DebtPayoffStatus {
  loading,
  success,
  failure,
}

class DebtPayoffState extends Equatable {
  final List<Debt> debtList;
  final DebtPayoffStatus status;
  final String? errorMessage;

  DebtPayoffState(
      {this.debtList = const [],
      this.status = DebtPayoffStatus.loading,
      this.errorMessage});

  DebtPayoffState copyWith({
    List<Debt>? debtList,
    DebtPayoffStatus? status,
    String? errorMessage,
  }) {
    return DebtPayoffState(
        debtList: debtList ?? this.debtList,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object?> get props => [debtList, status, errorMessage];
}
