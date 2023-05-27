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
      fetchTransactions(
          categoryId: state.lastCategoryId,
          date: state.lastDate ?? DateTime.now());
    });
  }

  Future<void> fetchTransactions(
      {required categoryId, required DateTime date}) async {
    emit(state.copyWith(status: TransactionsStatus.loading));
    try {
      final result = await _transactionsRepository.fetchAllTransactions(
          budgetId: _budgetId, dateTime: date, categoryId: categoryId);
      emit(
        state.copyWith(
            status: TransactionsStatus.success,
            transactionList: result,
            lastCategoryId: categoryId,
            lastDate: date),
      );
    } catch (e) {
      emit(state.copyWith(
          status: TransactionsStatus.failure, errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _transactionsSubscription.cancel();
    return super.close();
  }
}
