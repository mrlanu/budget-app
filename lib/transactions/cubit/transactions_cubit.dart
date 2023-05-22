import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/transaction.dart';
import '../models/transaction_view.dart';
import '../repository/transactions_repository.dart';

part 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  final TransactionsRepository _transactionsRepository;
  final String _budgetId;

  TransactionsCubit({
    required String budgetId,
    required TransactionsRepository transactionsRepository,
  })  : _transactionsRepository = transactionsRepository,
        _budgetId = budgetId,
        super(TransactionsState());

  Future<void> fetchTransactions(
      {required categoryId, required DateTime date}) async {
    emit(state.copyWith(status: TransactionsStatus.loading));
    try {
      final result = await _transactionsRepository.fetchAllTransactionView(
          budgetId: _budgetId,
          dateTime: date,
          categoryId: categoryId);
      emit(state.copyWith(
          status: TransactionsStatus.success, transactionList: result));
    } catch (e) {
      emit(state.copyWith(
          status: TransactionsStatus.failure, errorMessage: e.toString()));
    }
  }
}
