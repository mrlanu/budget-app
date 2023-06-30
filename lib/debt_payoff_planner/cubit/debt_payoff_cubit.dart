import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/debt.dart';
import '../repository/debts_repository.dart';

part 'debt_payoff_state.dart';

class DebtPayoffCubit extends Cubit<DebtPayoffState> {
  final DebtsRepository _debtsRepository;

  DebtPayoffCubit({required DebtsRepository debtsRepository})
      : _debtsRepository = debtsRepository,
        super(DebtPayoffState());

  Future<void> initRequested() async {
    emit(state.copyWith(status: DebtPayoffStatus.loading));
    final debtList = await _debtsRepository.fetchAllDebts();
    emit(state.copyWith(debtList: debtList, status: DebtPayoffStatus.success));
  }
}
