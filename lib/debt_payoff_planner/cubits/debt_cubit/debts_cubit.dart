import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/debt.dart';
import '../../repository/debts_repository.dart';

part 'debts_state.dart';

class DebtsCubit extends Cubit<DebtsState> {
  final DebtsRepository _debtsRepository;

  DebtsCubit({required DebtsRepository debtsRepository})
      : _debtsRepository = debtsRepository,
        super(DebtsState());

  Future<void> updateDebts() async {
    emit(state.copyWith(status: DebtsStatus.loading));
    final debtList = await _debtsRepository.fetchAllDebts();
    emit(state.copyWith(debtList: debtList, status: DebtsStatus.success));
  }

  Future<void> deleteDebt(String debtId)async {
    await _debtsRepository.deleteDebt(debtId: debtId);
    final debtList = await _debtsRepository.fetchAllDebts();
    emit(state.copyWith(debtList: debtList, status: DebtsStatus.success));
  }
}
