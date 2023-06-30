import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

part 'debt_payoff_strategy.g.dart';

@JsonSerializable()
class DebtPayoffStrategy extends Equatable {
  final int totalDuration;
  final double totalInterest;
  final DateTime debtFreeDate;
  final List<DebtStrategyReport> reports;

  DebtPayoffStrategy(
      {required this.totalDuration,
      required this.totalInterest,
      required this.debtFreeDate,
      required this.reports});

  factory DebtPayoffStrategy.fromJson(Map<String, dynamic> json) => _$DebtPayoffStrategyFromJson(json);

  Map<String, dynamic> toJson() => _$DebtPayoffStrategyToJson(this);

  @override
  List<Object?> get props => [totalDuration, totalInterest, debtFreeDate, reports];
}
