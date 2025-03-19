import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:qruto_budget/accounts_list/account_edit/model/account_with_details.dart';
import 'package:qruto_budget/categories/repository/category_repository.dart';
import 'package:qruto_budget/database/transaction_with_detail.dart';
import "package:collection/collection.dart";
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../transaction/transaction.dart';
import '../../accounts_list/repository/account_repository.dart';
import '../../database/database.dart';
import '../models/summary_tile.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final TransactionRepository _transactionsRepository;
  final CategoryRepository _categoryRepository;
  final AccountRepository _accountRepository;
  late final StreamSubscription _combinedSubscription;

  HomeCubit(
      {required TransactionRepository transactionsRepository,
      required CategoryRepository categoryRepository,
      required AccountRepository accountRepository})
      : _transactionsRepository = transactionsRepository,
        _categoryRepository = categoryRepository,
        _accountRepository = accountRepository,
        super(HomeState(selectedDate: DateTime.now())) {}

  Future<void> initRequested() async {
    emit(state.copyWith(status: HomeStatus.loading));
    _transactionsRepository.fetchTransactions(DateTime.now());
    _combinedSubscription = Rx.combineLatest3(
      _transactionsRepository.transactions,
      _categoryRepository.categories,
      _accountRepository.accounts,
      (transactions, categories, accounts) {
        return (transactions, categories, accounts);
      },
    ).listen((record) {
      emit(
        state.copyWith(
          status: HomeStatus.success,
          transactions: record.$1,
          categories: record.$2,
          accounts: record.$3,
        ),
      );
    }, onError: (_) => emit(state.copyWith(
        status: HomeStatus.failure, errorMessage: 'Something went wrong')));
  }

  /*Future<String> _checkInitialBudget() async {
    try {
      final budgetIds = await _budgetRepository.fetchAvailableBudgets();
      String currentBudgetId;
      if (budgetIds.isEmpty) {
        currentBudgetId = await _budgetRepository.createBeginningBudget();
      } else {
        currentBudgetId = budgetIds.first;
      }
      Cache.instance.setBudgetId(budgetId: currentBudgetId);
      return currentBudgetId;
    } catch (e) {
      rethrow;
    }
  }*/

  Future<void> setTab(int tabIndex) async {
    emit(state.copyWith(
        status: HomeStatus.loading, tab: HomeTab.values[tabIndex]));
    emit(state.copyWith(status: HomeStatus.success));
  }

  Future<void> changeDate(DateTime dateTime) async {
    emit(state.copyWith(status: HomeStatus.loading, selectedDate: dateTime));
    _transactionsRepository.fetchTransactions(dateTime);
  }

  Future<void> deleteTransaction({required int transactionId}) async {
    final transaction =
        await _transactionsRepository.getTransactionById(transactionId);
    final lastDeleted =
        state.transactions.where((tr) => tr.id == transaction.id).first;
    await _transactionsRepository.deleteTransactionOrTransfer(
        transactionId: transactionId);
    transaction.type == TransactionType.TRANSFER
        ? _updateBudgetOnDeleteTransfer(transaction: transaction)
        : _updateBudgetOnDeleteTransaction(transaction: transaction);
    emit(state.copyWith(lastDeletedTransaction: () => lastDeleted));
  }

  Future<void> undoDelete() async {
    final lT = state.lastDeletedTransaction;
    await _transactionsRepository.insertTransaction(
        amount: lT!.amount,
        date: lT.date,
        type: lT.type,
        fromAccountId: lT.fromAccount.id,
        subcategoryId: lT.subcategory!.id,
        categoryId: lT.category!.id,
        description: lT.description);
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
      {required TransactionWithDetails transaction}) async {
    final accounts = await _accountRepository.getAllAccounts();
    List<Account> updatedAccounts = [...accounts];
    updatedAccounts = updatedAccounts.map((acc) {
      if (acc.id == transaction.fromAccount.id) {
        return acc.copyWith(
            balance: acc.balance +
                (transaction.type == TransactionType.EXPENSE
                    ? transaction.amount
                    : -transaction.amount));
      } else {
        return acc;
      }
    }).toList();

    _updateAccounts(updatedAccounts);
  }

  void _updateBudgetOnDeleteTransfer(
      {required TransactionWithDetails transaction}) async {
    List<Account> updatedAccounts = [];
    final accounts = await _accountRepository.getAllAccounts();
    //find the acc from editedTransaction and return amount
    //find the acc from transaction and update amount
    updatedAccounts = accounts.map((acc) {
      if (acc.id == transaction.fromAccount.id) {
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

    _updateAccounts(updatedAccounts);
  }

  void _updateBudgetOnUndoDeleteTransaction(
      {required TransactionWithDetails transaction}) async {
    final accounts = await _accountRepository.getAllAccounts();
    var updatedAccounts = [...accounts];
    updatedAccounts = updatedAccounts.map((acc) {
      if (acc.id == transaction.fromAccount.id) {
        return acc.copyWith(
            balance: acc.balance +
                (transaction.type == TransactionType.EXPENSE
                    ? -transaction.amount
                    : transaction.amount));
      } else {
        return acc;
      }
    }).toList();

    _updateAccounts(updatedAccounts);
  }

  void _updateBudgetOnUndoDeleteTransfer(
      {required TransactionWithDetails transfer}) {
    /*final accounts = state.budget.accountList;
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

    _budgetRepository.pushUpdatedAccounts(updatedAccounts);*/
  }

  void _updateAccounts(List<Account> updatedAccounts) {
    updatedAccounts.forEach(
      (acc) => _accountRepository.updateAccount(
          id: acc.id,
          name: acc.name,
          includeInTotal: acc.includeInTotal,
          balance: acc.balance,
          initialBalance: acc.initialBalance,
          currency: acc.currency ?? '',
          categoryId: acc.categoryId),
    );
  }

  Future<void> deleteBudget() async {
    //await _budgetRepository.deleteBudget();
  }

  @override
  Future<void> close() {
    _combinedSubscription.cancel();
    return super.close();
  }
}
