import 'package:equatable/equatable.dart';

/// Total balance across included accounts at the start of [monthStart] (local midnight).
class NetWorthMonthPoint extends Equatable {
  const NetWorthMonthPoint({
    required this.monthStart,
    required this.totalBalance,
  });

  final DateTime monthStart;
  final double totalBalance;

  @override
  List<Object?> get props => [monthStart, totalBalance];
}
