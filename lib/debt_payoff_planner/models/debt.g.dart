// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Debt _$DebtFromJson(Map<String, dynamic> json) => Debt(
      id: json['id'] as String?,
      name: json['name'] as String,
      startBalance: (json['startBalance'] as num).toDouble(),
      currentBalance: (json['currentBalance'] as num).toDouble(),
      apr: (json['apr'] as num).toDouble(),
      minimumPayment: (json['minimumPayment'] as num).toDouble(),
      nextPaymentDue: DateTime.parse(json['nextPaymentDue'] as String),
      paymentsList: json['paymentsList'] as List<dynamic>? ?? const [],
      budgetId: json['budgetId'] as String,
    );

Map<String, dynamic> _$DebtToJson(Debt instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'startBalance': instance.startBalance,
      'currentBalance': instance.currentBalance,
      'apr': instance.apr,
      'minimumPayment': instance.minimumPayment,
      'nextPaymentDue': instance.nextPaymentDue.toIso8601String(),
      'paymentsList': instance.paymentsList,
      'budgetId': instance.budgetId,
    };
