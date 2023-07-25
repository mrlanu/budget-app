// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'year_month_sum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YearMonthSum _$YearMonthSumFromJson(Map<String, dynamic> json) => YearMonthSum(
      date: json['date'] as String,
      expenseSum: (json['expenseSum'] as num).toDouble(),
      incomeSum: (json['incomeSum'] as num).toDouble(),
    );

Map<String, dynamic> _$YearMonthSumToJson(YearMonthSum instance) =>
    <String, dynamic>{
      'date': instance.date,
      'expenseSum': instance.expenseSum,
      'incomeSum': instance.incomeSum,
    };
