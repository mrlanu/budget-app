part of 'debts_cubit.dart';

enum DebtsStatus {
  loading,
  success,
  failure,
}

class DebtsState extends Equatable {
  final List<Debt> debtList;
  final Map<int, Payment?> lastPayments;
  final DebtsStatus status;
  final String? errorMessage;

  DebtsState({
    this.debtList = const [],
    this.lastPayments = const {},
    this.status = DebtsStatus.loading,
    this.errorMessage,
  });

  DebtsState copyWith({
    List<Debt>? debtList,
    Map<int, Payment?>? lastPayments,
    DebtsStatus? status,
    String? errorMessage,
  }) {
    return DebtsState(
      debtList: debtList ?? this.debtList,
      lastPayments: lastPayments ?? this.lastPayments,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isDebtFree =>
      debtList.isNotEmpty && debtList.every((d) => d.currentBalance <= 0);

  @override
  List<Object?> get props => [debtList, lastPayments, status, errorMessage];
}
