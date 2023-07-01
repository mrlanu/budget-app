part of 'debt_bloc.dart';

sealed class DebtEvent extends Equatable {
  const DebtEvent();
}

final class FormInitEvent extends DebtEvent {
  final Debt? debt;

  const FormInitEvent({this.debt});

  @override
  List<Object?> get props => [debt];
}

final class NameChanged extends DebtEvent {
  const NameChanged({required this.name});

  final String name;

  @override
  List<Object> get props => [name];
}

final class BalanceChanged extends DebtEvent {
  const BalanceChanged({required this.balance});

  final String balance;

  @override
  List<Object> get props => [balance];
}

final class MinPaymentChanged extends DebtEvent {
  const MinPaymentChanged({required this.payment});

  final String payment;

  @override
  List<Object> get props => [payment];
}

final class AprChanged extends DebtEvent {
  const AprChanged({required this.apr});

  final String apr;

  @override
  List<Object> get props => [apr];
}

final class DebtFormSubmitted extends DebtEvent {
  final BuildContext context;

  DebtFormSubmitted({required this.context});

  @override
  List<Object> get props => [context];
}





