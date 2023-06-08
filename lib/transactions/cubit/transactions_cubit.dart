import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/transaction.dart';
import '../repository/transactions_repository.dart';

part 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  final TransactionsRepository _transactionsRepository;
  final String _budgetId;
  late final StreamSubscription<List<Transaction>> _transactionsSubscription;

  TransactionsCubit({
    required String budgetId,
    required TransactionsRepository transactionsRepository,
    required TransactionsFilter filterBy,
    required String filterId,
    required DateTime filterDate,
  })  : _transactionsRepository = transactionsRepository,
        _budgetId = budgetId,
        super(TransactionsState(
            filterBy: filterBy, filterId: filterId, filterDate: filterDate)) {
    _transactionsSubscription = _transactionsRepository
        .getTransactions()
        .skip(1)
        .listen((transactions) {
          fetchTransactions();
    });
  }

  Future<void> fetchTransactions() async {
    emit(state.copyWith(status: TransactionsStatus.loading));
    try {
      emit(state.copyWith(status: TransactionsStatus.loading));
      final result = await _transactionsRepository.fetchAllTransactions(
          budgetId: _budgetId,
          filterBy: state.filterBy,
          filterId: state.filterId,
          dateTime: state.filterDate!);
      emit(
        state.copyWith(
          status: TransactionsStatus.success,
          transactionList: result,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
          status: TransactionsStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> deleteTransaction({required Transaction transaction}) async {
    await _transactionsRepository.deleteTransaction(transaction.id!);
    fetchTransactions();
    emit(state.copyWith(lastDeletedTransaction: () => transaction));
  }

  Future<void> undoDelete() async {
    final tr = state.lastDeletedTransaction!;
    emit(state.copyWith(lastDeletedTransaction: () => null));
    await _transactionsRepository
        .createTransaction(tr);
    fetchTransactions();
  }

  @override
  Future<void> close() {
    _transactionsSubscription.cancel();
    return super.close();
  }
}
