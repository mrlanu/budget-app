import 'dart:async';

import 'package:bloc/bloc.dart';
import "package:collection/collection.dart";
import 'package:equatable/equatable.dart';

import '../../../transaction/transaction.dart';
import '../../accounts_list/models/account.dart';
import '../models/summary_tile.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final TransactionsRepository _transactionsRepository;
  late final StreamSubscription _transactionsSubscriptions;

  HomeCubit({
    required TransactionsRepository transactionsRepository,
  })  : _transactionsRepository = transactionsRepository,
        super(HomeState(selectedDate: DateTime.now())) {}

  Future<void> initRequested() async {
    emit(state.copyWith(status: HomeStatus.loading));

    _transactionsRepository.fetchTransactions(DateTime.now());

    _transactionsSubscriptions = _transactionsRepository.transactions.listen(
        (transactions) {
      emit(state.copyWith(
          status: HomeStatus.success,
          transactionList:
              _mapTransactionsToComprehensiveTr(transactions)));
    },
        onError: (_) => emit(state.copyWith(
            status: HomeStatus.failure, errorMessage: 'Something went wrong')));
  }

  List<ComprehensiveTransaction> _mapTransactionsToComprehensiveTr(
      List<Transaction> transactions) {
    final trList = transactions
        .map((t) => t.toTile())
        .expand((list) => list)
        .toList();
    trList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return trList;
  }

  Future<void> setTab(int tabIndex) async {
    emit(state.copyWith(
        status: HomeStatus.loading, tab: HomeTab.values[tabIndex]));
    emit(state.copyWith(status: HomeStatus.success));
  }

  Future<void> changeDate(DateTime dateTime) async {
    emit(state.copyWith(status: HomeStatus.loading, selectedDate: dateTime));
    _transactionsRepository.fetchTransactions(dateTime);
  }

  Future<void> deleteTransaction(
      {required ComprehensiveTransaction transaction}) async {
   /* await _transactionsRepository.deleteTransactionOrTransfer(
        transaction: transaction);
    final lastDeleted =
        state.transactionList.where((tr) => tr.id == transaction.id).first;
    transaction.type == TransactionType.TRANSFER
        ? _updateBudgetOnDeleteTransfer(transaction: transaction)
        : _updateBudgetOnDeleteTransaction(transaction: transaction);
    emit(state.copyWith(lastDeletedTransaction: () => lastDeleted));*/
  }

  Future<void> undoDelete() async {
    /*await _transactionsRepository
        .createTransaction(state.lastDeletedTransaction!.toTransaction());
    if (state.lastDeletedTransaction!.type == TransactionType.TRANSFER) {
      _updateBudgetOnUndoDeleteTransfer(
          transfer: state.lastDeletedTransaction!);
    } else {
      _updateBudgetOnUndoDeleteTransaction(
          transaction: state.lastDeletedTransaction!);
    }
    emit(state.copyWith(
      lastDeletedTransaction: () => null,
    ));*/
  }

  @override
  Future<void> close() {
    _transactionsSubscriptions.cancel();
    return super.close();
  }
}
