import 'dart:async';

import 'package:bloc/bloc.dart';
import "package:collection/collection.dart";
import 'package:equatable/equatable.dart';

import '../../../transaction/transaction.dart';
import '../../accounts_list/models/account.dart';
import '../models/summary_tile.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final BudgetRepository _budgetRepository;
  late StreamSubscription _transactionsSubscriptions;
  late StreamSubscription _accountsSubscriptions;

  HomeCubit({
    required BudgetRepository budgetRepository,
  })  : _budgetRepository = budgetRepository,
        super(HomeState(selectedDate: DateTime.now())) {
    _accountsSubscriptions = _budgetRepository.accounts.listen((accounts) {
      emit(state.copyWith(accountList: accounts));
    });
  }

  Future<void> initRequested() async {
    emit(state.copyWith(status: HomeStatus.loading));
    _transactionsSubscriptions = _budgetRepository
        .transactionsByDate(DateTime.now())
        .listen((transactions) {
      emit(state.copyWith(
          status: HomeStatus.success,
          transactionList: _mapTransactionsToComprehensiveTr(transactions)));
    },
            onError: (_) => emit(state.copyWith(
                status: HomeStatus.failure,
                errorMessage: 'Something went wrong')));
  }

  List<ComprehensiveTransaction> _mapTransactionsToComprehensiveTr(
      List<Transaction> transactions) {
    final trList =
        transactions.map((t) => t.toTile()).expand((list) => list).toList();
    trList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return trList;
  }

  Future<void> setTab(int tabIndex) async {
    emit(state.copyWith(
        status: HomeStatus.loading, tab: HomeTab.values[tabIndex]));
    emit(state.copyWith(status: HomeStatus.success));
  }

  Future<void> changeDate(DateTime dateTime) async {
    _transactionsSubscriptions.cancel();
    _transactionsSubscriptions = _budgetRepository
        .transactionsByDate(dateTime)
        .listen((transactions) {
      emit(state.copyWith(
          selectedDate: dateTime,
          transactionList: _mapTransactionsToComprehensiveTr(transactions)));
    },
            onError: (_) => emit(state.copyWith(
                status: HomeStatus.failure,
                errorMessage: 'Something went wrong')));
  }

  Future<void> deleteTransaction(
      {required ComprehensiveTransaction transaction}) async {
    final index =
        state.transactionList.indexWhere((tr) => tr.id == transaction.id);
    final transactionListCopy = [...state.transactionList];
    transactionListCopy.removeAt(index);
    emit(state.copyWith(transactionList: transactionListCopy));
    await _budgetRepository.deleteTransactionOrTransfer(
        transaction: transaction);
    transaction.type == TransactionType.TRANSFER
        ? await _updateBudgetOnDeleteTransfer(transaction: transaction)
        : await _updateBudgetOnDeleteTransaction(transaction: transaction);
    emit(state.copyWith(lastDeletedTransaction: () => transaction));
  }

  Future<void> undoDelete() async {
    await _budgetRepository
        .saveTransaction(state.lastDeletedTransaction!.toTransaction());
    if (state.lastDeletedTransaction!.type == TransactionType.TRANSFER) {
      await _updateBudgetOnUndoDeleteTransfer(
          transfer: state.lastDeletedTransaction!);
    } else {
      await _updateBudgetOnUndoDeleteTransaction(
          transaction: state.lastDeletedTransaction!);
    }
    emit(state.copyWith(
      lastDeletedTransaction: () => null,
    ));
  }

  Future<void> deleteBudget() async {
    await _budgetRepository.clearAll();
  }

  @override
  Future<void> close() {
    _transactionsSubscriptions.cancel();
    _accountsSubscriptions.cancel();
    return super.close();
  }

  Future<void> _updateBudgetOnDeleteTransaction(
      {required ComprehensiveTransaction transaction}) async {
    final accounts = state.accountList;
    List<Account> updatedAccounts = [...accounts];
    updatedAccounts = updatedAccounts.map((acc) {
      if (acc.id == transaction.fromAccount!.id) {
        return acc.copyWith(
            balance: acc.balance +
                (transaction.type == TransactionType.EXPENSE
                    ? transaction.amount
                    : -transaction.amount));
      } else {
        return acc;
      }
    }).toList();

    await _budgetRepository.saveAccounts(updatedAccounts);
  }

  Future<void> _updateBudgetOnDeleteTransfer(
      {required ComprehensiveTransaction transaction}) async {
    List<Account> updatedAccounts = [];
    final accounts = state.accountList;
    //find the acc from editedTransaction and return amount
    //find the acc from transaction and update amount
    updatedAccounts = accounts.map((acc) {
      if (acc.id == transaction.fromAccount!.id) {
        return acc.copyWith(balance: acc.balance + transaction.amount);
      } else {
        return acc;
      }
    }).toList();
    updatedAccounts = updatedAccounts.map((acc) {
      if (acc.id == transaction.toAccount!.id) {
        return acc.copyWith(balance: acc.balance - transaction.amount);
      } else {
        return acc;
      }
    }).toList();

    await _budgetRepository.saveAccounts(updatedAccounts);
  }

  Future<void> _updateBudgetOnUndoDeleteTransaction(
      {required ComprehensiveTransaction transaction,
      ComprehensiveTransaction? editedTransaction}) async {
    final accounts = state.accountList;
    var updatedAccounts = [...accounts];
    updatedAccounts = updatedAccounts.map((acc) {
      if (acc.id == transaction.fromAccount!.id) {
        return acc.copyWith(
            balance: acc.balance +
                (transaction.type == TransactionType.EXPENSE
                    ? -transaction.amount
                    : transaction.amount));
      } else {
        return acc;
      }
    }).toList();

    await _budgetRepository.saveAccounts(updatedAccounts);
  }

  Future<void> _updateBudgetOnUndoDeleteTransfer(
      {required ComprehensiveTransaction transfer}) async {
    final accounts = state.accountList;
    List<Account> updatedAccounts = [];

    //find the acc from editedTransaction and return amount
    //find the acc from transaction and update amount
    updatedAccounts = accounts.map((acc) {
      if (acc.id == transfer.fromAccount!.id) {
        return acc.copyWith(balance: acc.balance - transfer.amount);
      } else {
        return acc;
      }
    }).toList();
    updatedAccounts = updatedAccounts.map((acc) {
      if (acc.id == transfer.toAccount!.id) {
        return acc.copyWith(balance: acc.balance + transfer.amount);
      } else {
        return acc;
      }
    }).toList();

    await _budgetRepository.saveAccounts(updatedAccounts);
  }
}
