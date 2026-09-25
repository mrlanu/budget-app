import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../database/database.dart';
import '../../repository/debts_repository.dart';
import '../debt_form.dart';

part 'debt_event.dart';
part 'debt_state.dart';

class DebtBloc extends Bloc<DebtEvent, DebtState> {
  final DebtsRepository _debtRepository;

  DebtBloc({required DebtsRepository debtsRepository})
      : _debtRepository = debtsRepository,
        super(DebtState.initial()) {
    on<DebtEvent>(_onEvent, transformer: sequential());
  }

  Future<void> _onEvent(DebtEvent event, Emitter<DebtState> emit) {
    return switch (event) {
      final FormInitEvent e => _onFormInit(e, emit),
      final NameChanged e => _onNameChanged(e, emit),
      final BalanceChanged e => _onBalanceChanged(e, emit),
      final MinPaymentChanged e => _onMinPaymentChanged(e, emit),
      final AprChanged e => _onAprChanged(e, emit),
      final DueDateChanged e => _onDueDateChanged(e, emit),
      final DebtFormSubmitted e => _onFormSubmitted(e, emit),
    };
  }

  bool _validate({
    required String name,
    required MyDigit balance,
    required MyDigit minPayment,
    required MyDigit apr,
  }) {
    return name.trim().isNotEmpty &&
        Formz.validate([balance, apr, minPayment]);
  }

  Future<void> _onFormInit(FormInitEvent event, Emitter<DebtState> emit) async {
    final debt = event.debt;
    if (debt != null) {
      emit(state.copyWith(
        status: DebtStateStatus.success,
        id: debt.id,
        name: debt.name,
        startBalance: debt.startBalance,
        balance: MyDigit.dirty(debt.currentBalance.toString()),
        minPayment: MyDigit.dirty(debt.minimumPayment.toString()),
        apr: MyDigit.dirty(debt.apr.toString()),
        nextPaymentDue: debt.nextPaymentDue,
        isValid: true,
      ));
    } else {
      emit(state.copyWith(status: DebtStateStatus.success));
    }
  }

  Future<void> _onNameChanged(
      NameChanged event, Emitter<DebtState> emit) async {
    emit(state.copyWith(
      name: event.name,
      isValid: _validate(
        name: event.name,
        balance: state.balance,
        minPayment: state.minPayment,
        apr: state.apr,
      ),
    ));
  }

  Future<void> _onBalanceChanged(
      BalanceChanged event, Emitter<DebtState> emit) async {
    final balance = MyDigit.dirty(event.balance);
    emit(state.copyWith(
      balance: balance,
      isValid: _validate(
        name: state.name,
        balance: balance,
        minPayment: state.minPayment,
        apr: state.apr,
      ),
    ));
  }

  Future<void> _onMinPaymentChanged(
      MinPaymentChanged event, Emitter<DebtState> emit) async {
    final payment = MyDigit.dirty(event.payment);
    emit(state.copyWith(
      minPayment: payment,
      isValid: _validate(
        name: state.name,
        balance: state.balance,
        minPayment: payment,
        apr: state.apr,
      ),
    ));
  }

  Future<void> _onAprChanged(AprChanged event, Emitter<DebtState> emit) async {
    final apr = MyDigit.dirty(event.apr);
    emit(state.copyWith(
      apr: apr,
      isValid: _validate(
        name: state.name,
        balance: state.balance,
        minPayment: state.minPayment,
        apr: apr,
      ),
    ));
  }

  Future<void> _onDueDateChanged(
      DueDateChanged event, Emitter<DebtState> emit) async {
    emit(state.copyWith(nextPaymentDue: event.dueDate));
  }

  Future<void> _onFormSubmitted(
      DebtFormSubmitted event, Emitter<DebtState> emit) async {
    emit(state.copyWith(submissionStatus: FormzSubmissionStatus.inProgress));
    try {
      final currentBalance = double.parse(state.balance.value);
      final apr = double.parse(state.apr.value);
      final minPayment = double.parse(state.minPayment.value);
      final name = state.name.trim();

      if (state.id != null) {
        await _debtRepository.updateDebt(
          id: state.id!,
          name: name,
          startBalance: state.startBalance ?? currentBalance,
          currentBalance: currentBalance,
          nextPaymentDue: state.nextPaymentDue,
          apr: apr,
          minimumPayment: minPayment,
        );
      } else {
        await _debtRepository.insertDebt(
          name: name,
          startBalance: currentBalance,
          currentBalance: currentBalance,
          nextPaymentDue: state.nextPaymentDue,
          apr: apr,
          minimumPayment: minPayment,
        );
      }
      emit(state.copyWith(submissionStatus: FormzSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        submissionStatus: FormzSubmissionStatus.failure,
        errorMessage: 'Unknown Error',
      ));
    }
  }
}
