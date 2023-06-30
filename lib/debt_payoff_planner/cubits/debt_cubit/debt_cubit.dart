import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/debt.dart';
import '../../repository/debts_repository.dart';

part 'debt_state.dart';

class DebtCubit extends Cubit<DebtState> {
  final DebtsRepository _debtsRepository;

  DebtCubit({required DebtsRepository debtsRepository})
      : _debtsRepository = debtsRepository,
        super(DebtState());

  Future<void> initRequested() async {
    emit(state.copyWith(status: DebtStatus.loading));
    final debtList = await _debtsRepository.fetchAllDebts();
    emit(state.copyWith(debtList: debtList, status: DebtStatus.success));
  }
}
