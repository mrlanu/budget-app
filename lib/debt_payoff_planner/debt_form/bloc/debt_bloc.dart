import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cache/cache.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';

import '../../models/debt.dart';
import '../../repository/debts_repository.dart';
import '../debt_form.dart';

part 'debt_event.dart';
part 'debt_state.dart';

class DebtBloc extends Bloc<DebtEvent, DebtState> {
  final DebtsRepository _debtRepository;

  DebtBloc({required DebtsRepository debtsRepository})
      : _debtRepository = debtsRepository,
        super(DebtState()) {
    on<DebtEvent>(_onEvent, transformer: sequential());
  }

  Future<void> _onEvent(DebtEvent event, Emitter<DebtState> emit) {
    return switch (event) {
      final FormInitEvent e => _onFormInit(e, emit),
      final NameChanged e => _onNameChanged(e, emit),
      final BalanceChanged e => _onBalanceChanged(e, emit),
      final MinPaymentChanged e => _onMinPaymentChanged(e, emit),
      final AprChanged e => _onAprChanged(e, emit),
      final DebtFormSubmitted e => _onFormSubmitted(e, emit)
    };
  }

  Future<void> _onFormInit(FormInitEvent event, Emitter<DebtState> emit) async {
    final debt = event.debt;
    if (debt != null) {
      emit(state.copyWith(
        status: DebtStateStatus.success,
        id: debt.id,
        name: debt.name,
        balance: MyDigit.dirty(debt.startBalance.toString()),
        minPayment: MyDigit.dirty(debt.minimumPayment.toString()),
        apr: MyDigit.dirty(debt.apr.toString()),
        isValid: true,
      ));
    } else {
      emit(state.copyWith(status: DebtStateStatus.success));
    }
  }

  Future<void> _onNameChanged(
      NameChanged event, Emitter<DebtState> emit) async {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _onBalanceChanged(
      BalanceChanged event, Emitter<DebtState> emit) async {
    final balance = MyDigit.dirty(event.balance);
    emit(state.copyWith(
      balance: balance,
      isValid: Formz.validate([balance, state.apr, state.minPayment]),
    ));
  }

  Future<void> _onMinPaymentChanged(
      MinPaymentChanged event, Emitter<DebtState> emit) async {
    final payment = MyDigit.dirty(event.payment);
    emit(state.copyWith(
      minPayment: payment,
      isValid: Formz.validate([payment, state.apr, state.balance]),
    ));
  }

  Future<void> _onAprChanged(AprChanged event, Emitter<DebtState> emit) async {
    final apr = MyDigit.dirty(event.apr);
    emit(state.copyWith(
      apr: apr,
      isValid: Formz.validate([apr, state.balance, state.minPayment]),
    ));
  }

  Future<void> _onFormSubmitted(
      DebtFormSubmitted event, Emitter<DebtState> emit) async {
    emit(state.copyWith(submissionStatus: FormzSubmissionStatus.inProgress));
    try {
      final debt = await _debtRepository.saveDebt(
          debt: Debt(
              id: state.id,
              name: state.name,
              startBalance: double.parse(state.balance.value),
              currentBalance: double.parse(state.balance.value),
              nextPaymentDue: DateTime.now(),
              budgetId: await Cache.instance.getBudgetId()?? '',
              apr: double.parse(state.apr.value),
              minimumPayment: double.parse(state.minPayment.value)));
      emit(state.copyWith(submissionStatus: FormzSubmissionStatus.success));
      Navigator.pop(event.context);
    } on DebtFailure catch (e) {
      emit(state.copyWith(
          submissionStatus: FormzSubmissionStatus.failure,
          errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
          submissionStatus: FormzSubmissionStatus.failure,
          errorMessage: 'Unknown Error'));
    }
  }
}
