import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transfer.g.dart';

@JsonSerializable()
class Transfer extends Equatable{
  final String? id;
  final DateTime date;
  final String fromAccountId;
  final String toAccountId;
  final double amount;
  final String budgetId;
  final String? notes;

  Transfer(
      {this.id,
      required this.date,
      required this.fromAccountId,
      required this.toAccountId,
      required this.amount,
      required this.budgetId,
      this.notes});

  Transfer copyWith({
    String? id,
    DateTime? date,
    String? fromAccountId,
    String? toAccountId,
    double? amount,
    String? budgetId,
    String? notes
}){
    return Transfer(
      id: id ?? this.id,
      date: date ?? this.date,
      fromAccountId: fromAccountId ?? this.fromAccountId,
      toAccountId: toAccountId ?? this.toAccountId,
      amount: amount ?? this.amount,
      budgetId: budgetId ?? this.budgetId,
      notes: notes ?? this.notes,
    );
  }

  factory Transfer.fromJson(Map<String, dynamic> json) =>
      _$TransferFromJson(json);

  Map<String, dynamic> toJson() => _$TransferToJson(this);

  @override
  List<Object?> get props => [id, budgetId];
}
