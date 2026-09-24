import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:qruto_budget/database/recurring_transaction_with_detail.dart';
import 'package:qruto_budget/recurring/repository/recurring_repository.dart';

part 'recurring_state.dart';

class RecurringCubit extends Cubit<RecurringState> {
  RecurringCubit({required RecurringRepository recurringRepository})
      : _recurringRepository = recurringRepository,
        super(const RecurringState()) {
    _subscription = _recurringRepository.watchAll().listen((items) {
      emit(state.copyWith(status: RecurringStatus.success, items: items));
    });
  }

  final RecurringRepository _recurringRepository;
  late final StreamSubscription<List<RecurringTransactionWithDetails>>
      _subscription;

  Future<void> toggleActive(int id, bool isActive) =>
      _recurringRepository.setActive(id: id, isActive: isActive);

  Future<void> delete(int id) => _recurringRepository.deleteRecurring(id);

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
