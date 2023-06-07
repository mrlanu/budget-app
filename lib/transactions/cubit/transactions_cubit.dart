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
  })  : _transactionsRepository = transactionsRepository,
        _budgetId = budgetId,
        super(TransactionsState()) {
    _transactionsSubscription = _transactionsRepository
        .getTransactions()
        .skip(1)
        .listen((transactions) {
          emit(state.copyWith(transactionList: transactions));
    });
  }

  Future<void> fetchTransactions(
      {required TransactionsFilter filterBy, required String filterId, required DateTime date}) async {
    emit(state.copyWith(status: TransactionsStatus.loading));
    try {
      final result = await _transactionsRepository.fetchAllTransactions(
          budgetId: _budgetId, filterBy: filterBy, filterId: filterId ,dateTime: date);
      emit(
        state.copyWith(
            status: TransactionsStatus.success,
            transactionList: result,
            lastFilterId: filterId,
            lastDate: date),
      );
    } catch (e) {
      emit(state.copyWith(
          status: TransactionsStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> deleteTransaction({required Transaction transaction}) async {
    await _transactionsRepository.deleteTransaction(transaction.id!);
    emit(state.copyWith(lastDeletedTransaction: transaction));
  }

  Future<void> undoDelete() async {
    await _transactionsRepository.createTransaction(state.lastDeletedTransaction!);
  }

  @override
  Future<void> close() {
    _transactionsSubscription.cancel();
    return super.close();
  }
}
