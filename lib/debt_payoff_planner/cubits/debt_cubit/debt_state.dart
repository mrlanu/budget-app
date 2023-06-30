part of 'debt_cubit.dart';

enum DebtStatus {
  loading,
  success,
  failure,
}

class DebtState extends Equatable {
  final List<Debt> debtList;
  final DebtStatus status;
  final String? errorMessage;

  DebtState(
      {this.debtList = const [],
      this.status = DebtStatus.loading,
      this.errorMessage});

  DebtState copyWith({
    List<Debt>? debtList,
    DebtStatus? status,
    String? errorMessage,
  }) {
    return DebtState(
        debtList: debtList ?? this.debtList,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object?> get props => [debtList, status, errorMessage];
}
