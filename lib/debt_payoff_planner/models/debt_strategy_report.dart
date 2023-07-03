import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

part 'debt_strategy_report.g.dart';

@JsonSerializable()
class DebtStrategyReport extends Equatable{
  final int duration;
  final List<DebtReportItem> extraPayments;
  final List<DebtReportItem> minPayments;

  DebtStrategyReport(
      {required this.duration,
      required this.extraPayments,
      required this.minPayments});

  factory DebtStrategyReport.fromJson(Map<String, dynamic> json) => _$DebtStrategyReportFromJson(json);

  Map<String, dynamic> toJson() => _$DebtStrategyReportToJson(this);

  @override
  List<Object?> get props => [duration, extraPayments, minPayments];
}
