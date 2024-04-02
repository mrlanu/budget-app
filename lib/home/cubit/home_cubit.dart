import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/budgets/budgets.dart';
import 'package:cache_client/cache_client.dart';
import "package:collection/collection.dart";
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../transaction/transaction.dart';
import '../../accounts_list/models/account.dart';
import '../../budgets/repository/budget_repository.dart';
import '../models/summary_tile.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final TransactionsRepository _transactionsRepository;
  final BudgetRepository _budgetRepository;
  late final StreamSubscription _combinedSubscription;

  HomeCubit({
    required TransactionsRepository transactionsRepository,
    required BudgetRepository budgetRepository,
  })  : _transactionsRepository = transactionsRepository,
        _budgetRepository = budgetRepository,
        super(HomeState(selectedDate: DateTime.now())) {}

  Future<void> initRequested() async {
    emit(state.copyWith(status: HomeStatus.loading));
    String currentBudgetId = await _checkInitialBudget();

    await _budgetRepository.fetchBudget(currentBudgetId);
    _transactionsRepository.fetchTransactions(DateTime.now());

    _combinedSubscription = Rx.combineLatest2(
      _budgetRepository.budget,
      _transactionsRepository.transactions,
      (budget, transactions) {
        final transactionList =
            _mapTransactionsToComprehensiveTr(transactions, budget);
        return (
          transactionList: transactionList,
          budget: budget,
        );
      },
    ).listen((record) {
      emit(
        state.copyWith(
          status: HomeStatus.success,
          budget: record.budget,
          transactionList: record.transactionList,
        ),
      );
    },
        onError: (_) => emit(state.copyWith(
            status: HomeStatus.failure, errorMessage: 'Something went wrong')));
  }

  Future<String> _checkInitialBudget() async {
    try {
      final budgetIds = await _budgetRepository.fetchAvailableBudgets();
      String currentBudgetId;
      if (budgetIds.isEmpty) {
        currentBudgetId = await _budgetRepository.createBeginningBudget();
      } else {
        currentBudgetId = budgetIds.first;
      }
      CacheClient.instance.setBudgetId(budgetId: currentBudgetId);
      return currentBudgetId;
    } catch (e) {
      rethrow;
    }
  }

  List<ComprehensiveTransaction> _mapTransactionsToComprehensiveTr(
      List<Transaction> transactions, Budget budget) {
    final trList = transactions
        .map((t) => t.toTile(budget))
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
    await _transactionsRepository.deleteTransactionOrTransfer(
        transaction: transaction);
    final lastDeleted =
        state.transactionList.where((tr) => tr.id == transaction.id).first;
    transaction.type == TransactionType.TRANSFER
        ? _updateBudgetOnDeleteTransfer(transaction: transaction)
        : _updateBudgetOnDeleteTransaction(transaction: transaction);
    emit(state.copyWith(lastDeletedTransaction: () => lastDeleted));
  }

  Future<void> undoDelete() async {
    await _transactionsRepository
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
    ));
  }

  void _updateBudgetOnDeleteTransaction(
      {required ComprehensiveTransaction transaction}) {
    final accounts = state.budget.accountList;
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

    _budgetRepository.pushUpdatedAccounts(updatedAccounts);
  }

  void _updateBudgetOnDeleteTransfer(
      {required ComprehensiveTransaction transaction}) {
    List<Account> updatedAccounts = [];
    final accounts = state.budget.accountList;
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

    _budgetRepository.pushUpdatedAccounts(updatedAccounts);
  }

  void _updateBudgetOnUndoDeleteTransaction(
      {required ComprehensiveTransaction transaction,
      ComprehensiveTransaction? editedTransaction}) {
    final accounts = state.budget.accountList;
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

    _budgetRepository.pushUpdatedAccounts(updatedAccounts);
  }

  void _updateBudgetOnUndoDeleteTransfer(
      {required ComprehensiveTransaction transfer}) {
    final accounts = state.budget.accountList;
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

    _budgetRepository.pushUpdatedAccounts(updatedAccounts);
  }

  Future<void> deleteBudget() async {
    await _budgetRepository.deleteBudget();
  }

  @override
  Future<void> close() {
    _combinedSubscription.cancel();
    return super.close();
  }
}
