part of 'debts_cubit.dart';

enum DebtsStatus {
  loading,
  success,
  failure,
}

class DebtsState extends Equatable {
  final List<Debt> debtList;
  final DebtsStatus status;
  final String? errorMessage;

  DebtsState(
      {this.debtList = const [],
      this.status = DebtsStatus.loading,
      this.errorMessage});

  DebtsState copyWith({
    List<Debt>? debtList,
    DebtsStatus? status,
    String? errorMessage,
  }) {
    return DebtsState(
        debtList: debtList ?? this.debtList,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object?> get props => [debtList, status, errorMessage];
}
