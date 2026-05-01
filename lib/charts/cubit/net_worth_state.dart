part of 'net_worth_cubit.dart';

enum NetWorthStatus { initial, loading, success, failure }

class NetWorthState extends Equatable {
  const NetWorthState({
    this.status = NetWorthStatus.initial,
    this.points = const [],
    this.errorMessage,
    this.includeHiddenAccounts = false,
  });

  final NetWorthStatus status;
  final List<NetWorthMonthPoint> points;
  final String? errorMessage;

  /// When true, accounts excluded from totals ([Account.includeInTotal] false) are included in net worth.
  final bool includeHiddenAccounts;

  NetWorthState copyWith({
    NetWorthStatus? status,
    List<NetWorthMonthPoint>? points,
    String? errorMessage,
    bool clearError = false,
    bool? includeHiddenAccounts,
  }) {
    return NetWorthState(
      status: status ?? this.status,
      points: points ?? this.points,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      includeHiddenAccounts:
          includeHiddenAccounts ?? this.includeHiddenAccounts,
    );
  }

  @override
  List<Object?> get props =>
      [status, points, errorMessage, includeHiddenAccounts];
}
