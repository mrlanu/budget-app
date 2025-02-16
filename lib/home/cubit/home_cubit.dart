import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/accounts_list/account_edit/model/account_with_details.dart';
import 'package:budget_app/categories/repository/category_repository.dart';
import 'package:budget_app/database/transaction_with_detail.dart';
import "package:collection/collection.dart";
import 'package:equatable/equatable.dart';

import '../../../transaction/transaction.dart';
import '../../accounts_list/repository/account_repository.dart';
import '../../database/database.dart';
import '../models/summary_tile.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final TransactionRepository _transactionsRepository;
  final CategoryRepository _categoryRepository;
  final AccountRepository _accountRepository;
  late final StreamSubscription _transactionsSubscription;
  late final StreamSubscription _categoriesSubscription;
  late final StreamSubscription _accountsSubscription;

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
    _transactionsSubscription = _transactionsRepository.transactions.listen(
        (transactions) {
      final transactionTiles = _mapTransactionsToTiles(transactions);
      emit(
        state.copyWith(
          status: HomeStatus.success,
          transactionTilesList: transactionTiles,
        ),
      );
    },
        onError: (_) => emit(state.copyWith(
            status: HomeStatus.failure, errorMessage: 'Something went wrong')));

    _categoriesSubscription = _categoryRepository.categories.listen(
        (categories) {
      emit(
        state.copyWith(
          status: HomeStatus.success,
          categories: categories,
        ),
      );
    },
        onError: (_) => emit(state.copyWith(
            status: HomeStatus.failure, errorMessage: 'Something went wrong')));

    _accountsSubscription = _accountRepository.accounts.listen((accounts) {
      emit(
        state.copyWith(
          status: HomeStatus.success,
          accounts: accounts,
        ),
      );
    },
        onError: (_) => emit(state.copyWith(
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

  List<TransactionTile> _mapTransactionsToTiles(
      List<TransactionWithDetails> transactions) {
    final trList =
        transactions.map((t) => _toTile(t)).expand((list) => list).toList();
    trList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return trList;
  }

  List<TransactionTile> _toTile(TransactionWithDetails transaction) {
    switch (transaction.type) {
      case TransactionType.EXPENSE || TransactionType.INCOME:
        return [
          TransactionTile(
              id: transaction.id,
              type: transaction.type,
              amount: transaction.amount,
              title: transaction.subcategory.name,
              subtitle: transaction.fromAccount.name,
              dateTime: transaction.date,
              description: transaction.description,
              category: transaction.category,
              subcategory: transaction.subcategory,
              fromAccount: transaction.fromAccount)
        ];
      case TransactionType.TRANSFER:
        return [
          TransactionTile(
            id: transaction.id,
            type: TransactionType.TRANSFER,
            amount: transaction.amount,
            title: 'Transfer in',
            subtitle: 'from ${transaction.fromAccount.name}',
            dateTime: transaction.date,
            description: transaction.description,
            fromAccount: transaction.fromAccount,
            toAccount: transaction.toAccount,
          ),
          TransactionTile(
              id: transaction.id,
              type: TransactionType.TRANSFER,
              amount: transaction.amount,
              title: 'Transfer out',
              subtitle: 'to ${transaction.toAccount!.name}',
              dateTime: transaction.date,
              description: transaction.description,
              fromAccount: transaction.fromAccount,
              toAccount: transaction.toAccount)
        ];
      case _:
        return [];
    }
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

  Future<void> deleteTransaction({required TransactionTile transaction}) async {
    await _transactionsRepository.deleteTransactionOrTransfer(
        transaction: transaction);
    final lastDeleted =
        state.transactionTilesList.where((tr) => tr.id == transaction.id).first;
    transaction.type == TransactionType.TRANSFER
        ? _updateBudgetOnDeleteTransfer(transaction: transaction)
        : _updateBudgetOnDeleteTransaction(transaction: transaction);
    emit(state.copyWith(lastDeletedTransaction: () => lastDeleted));
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

  void _updateBudgetOnDeleteTransaction(
      {required TransactionTile transaction}) {
    /*final accounts = state.budget.accountList;
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

    _budgetRepository.pushUpdatedAccounts(updatedAccounts);*/
  }

  void _updateBudgetOnDeleteTransfer({required TransactionTile transaction}) {
    List<AccountWithDetails> updatedAccounts = [];
    final accounts = state.accounts;
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

    //_budgetRepository.pushUpdatedAccounts(updatedAccounts);
  }

  void _updateBudgetOnUndoDeleteTransaction(
      {required TransactionTile transaction,
      TransactionTile? editedTransaction}) {
    /*final accounts = state.budget.accountList;
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

    _budgetRepository.pushUpdatedAccounts(updatedAccounts);*/
  }

  void _updateBudgetOnUndoDeleteTransfer({required TransactionTile transfer}) {
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

  Future<void> deleteBudget() async {
    //await _budgetRepository.deleteBudget();
  }

  @override
  Future<void> close() {
    _transactionsSubscription.cancel();
    _categoriesSubscription.cancel();
    _accountsSubscription.cancel();
    return super.close();
  }
}
