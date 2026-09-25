import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../database/database.dart';
import '../../repository/debts_repository.dart';

part 'debts_state.dart';

class DebtsCubit extends Cubit<DebtsState> {
  final DebtsRepository _debtsRepository;

  DebtsCubit({required DebtsRepository debtsRepository})
      : _debtsRepository = debtsRepository,
        super(DebtsState());

  Future<void> updateDebts() async {
    emit(state.copyWith(status: DebtsStatus.loading));
    try {
      final debtList = await _debtsRepository.fetchAllDebts();
      final lastPayments = await _debtsRepository
          .getLastPaymentsForDebts(debtList.map((d) => d.id).toList());
      emit(state.copyWith(
        debtList: debtList,
        lastPayments: lastPayments,
        status: DebtsStatus.success,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: DebtsStatus.failure,
        errorMessage: 'Failed to load debts',
      ));
    }
  }

  Future<void> deleteDebt(int debtId) async {
    await _debtsRepository.deleteDebt(debtId: debtId);
    await updateDebts();
  }

  Future<void> recordPayment({
    required int debtId,
    required double amount,
    required DateTime date,
  }) async {
    await _debtsRepository.recordPayment(
      debtId: debtId,
      amount: amount,
      date: date,
    );
    await updateDebts();
  }

  Future<void> updatePayment({
    required int paymentId,
    required double amount,
    required DateTime date,
  }) async {
    await _debtsRepository.updatePayment(
      paymentId: paymentId,
      amount: amount,
      date: date,
    );
    await updateDebts();
  }

  Future<void> deletePayment({required int paymentId}) async {
    await _debtsRepository.deletePayment(paymentId: paymentId);
    await updateDebts();
  }

  Future<List<Payment>> paymentsForDebt(int debtId) =>
      _debtsRepository.getPaymentsForDebt(debtId);
}
