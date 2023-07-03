import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'debt.g.dart';

@JsonSerializable()
class Debt extends Equatable {
  final String? id;
  final String name;
  final double startBalance;
  final double currentBalance;
  final double apr;
  final double minimumPayment;
  final DateTime nextPaymentDue;
  final List<dynamic> paymentsList;
  final String budgetId;

  Debt({
    this.id,
    required this.name,
    required this.startBalance,
    required this.currentBalance,
    required this.apr,
    required this.minimumPayment,
    required this.nextPaymentDue,
    this.paymentsList = const [],
    required this.budgetId,
  });

  Debt copyWith({
    String? id,
    String? name,
    double? startBalance,
    double? currentBalance,
    double? apr,
    double? minimumPayment,
    DateTime? nextPaymentDue,
    List<dynamic>? paymentsList,
    String? budgetId,
  }) =>
      Debt(
        id: id ?? this.id,
        name: name ?? this.name,
        startBalance: startBalance ?? this.startBalance,
        currentBalance: currentBalance ?? this.currentBalance,
        apr: apr ?? this.apr,
        minimumPayment: minimumPayment ?? this.minimumPayment,
        nextPaymentDue: nextPaymentDue ?? this.nextPaymentDue,
        paymentsList: paymentsList ?? this.paymentsList,
        budgetId: budgetId ?? this.budgetId,
      );

  factory Debt.fromJson(Map<String, dynamic> json) => _$DebtFromJson(json);

  Map<String, dynamic> toJson() => _$DebtToJson(this);

  @override
  String toString() {
    return 'Debt: {id: $id, name: $name, startBalance: $startBalance, currentBalance: $currentBalance';
  }

  @override
  List<Object?> get props =>
      [id, name, startBalance, currentBalance, apr, minimumPayment, budgetId];
}
