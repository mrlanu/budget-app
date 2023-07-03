import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'debt_report_item.g.dart';

@JsonSerializable()
class DebtReportItem extends Equatable{
  final String name;
  final double amount;
  final bool paid;

  DebtReportItem({required this.name, required this.amount, required this.paid});

  factory DebtReportItem.fromJson(Map<String, dynamic> json) => _$DebtReportItemFromJson(json);

  Map<String, dynamic> toJson() => _$DebtReportItemToJson(this);

  @override
  List<Object?> get props => [name, amount, paid];
}
