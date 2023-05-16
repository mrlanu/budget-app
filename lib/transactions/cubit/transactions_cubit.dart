import 'package:bloc/bloc.dart';
import 'package:budget_app/transactions/models/transaction.dart';
import 'package:equatable/equatable.dart';

import '../models/transaction_view.dart';
import '../repository/transactions_repository.dart';

part 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  final TransactionsRepository _transactionsRepository;

  TransactionsCubit({required TransactionsRepository transactionsRepository, })
      : _transactionsRepository = transactionsRepository,
        super(TransactionsState());

  Future<void> fetchTransactions(
      {required categoryId, required DateTime date}) async {
    emit(state.copyWith(status: TransactionsStatus.loading));
    try {
      final result = await _transactionsRepository.fetchAllTransactionView(
          budgetId: '6459634ba996e636ed5a3667', dateTime: date, categoryId: categoryId);
      emit(state.copyWith(status: TransactionsStatus.success, transactionList: result));
    } catch(e) {
      emit(state.copyWith(status: TransactionsStatus.failure, errorMessage: e.toString()));
    }
  }
}
