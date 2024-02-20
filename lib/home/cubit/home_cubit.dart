import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/budgets/budgets.dart';
import 'package:budget_app/shared/models/transaction_interface.dart';
import 'package:budget_app/transfer/models/models.dart';
import "package:collection/collection.dart";
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/models/summary_tile.dart';
import '../../../transaction/transaction.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final TransactionsRepository _transactionsRepository;
  final BudgetRepository _budgetRepository;
  late final StreamSubscription<List<ITransaction>> _transactionsSubscription;
  late final StreamSubscription<Budget> _budgetSubscription;

  HomeCubit({
    required TransactionsRepository transactionsRepository,
    required BudgetRepository budgetRepository,
  })  : _transactionsRepository = transactionsRepository,
        _budgetRepository = budgetRepository,
        super(HomeState(selectedDate: DateTime.now())) {
    _init();
  }

  Future<void> _init() async {
    emit(state.copyWith(status: HomeStatus.loading));
    final budgetIds = await _budgetRepository.fetchAvailableBudgets();
    String currentBudgetId;
    if (budgetIds.isEmpty) {
      currentBudgetId = await _budgetRepository.createBeginningBudget();
    } else {
      currentBudgetId = budgetIds.first;
    }
    (await SharedPreferences.getInstance())
        .setString('currentBudgetId', currentBudgetId);
    await _budgetRepository.fetchBudget(currentBudgetId);
    _budgetSubscription = _budgetRepository.budget.listen((budget) {
      emit(state.copyWith(accounts: budget.accountList));
    }, onError: (err) {
      emit(state.copyWith(
          status: HomeStatus.failure,
          errorMessage: 'HomeCubit. Something went wrong'));
    });
    _transactionsSubscription =
        _transactionsRepository.transactions.listen((transactions) {
      _onTransactionsChanged(transactions);
    });
    _transactionsRepository.fetchTransactions(DateTime.now());
    try {} catch (e) {
      emit(state.copyWith(
          status: HomeStatus.failure, errorMessage: 'Something went wrong'));
    }
  }

  Future<void> _onTransactionsChanged(
      List<ITransaction> newTransactions) async {
    emit(state.copyWith(status: HomeStatus.loading));

    var trTiles = <TransactionTile>[];

    final transactions = newTransactions
        .where((tr) =>
            tr.getDate().month == state.selectedDate!.month &&
            tr.getDate().year == state.selectedDate!.year)
        .toList();

    transactions.forEach((tr) {
      if (tr.isTransaction()) {
        final transaction = tr as Transaction;
        final cat = _budgetRepository.getCategoryById(transaction.categoryId!);
        final subcategory = cat.subcategoryList
            .where((sc) => transaction.subcategoryId == sc.id)
            .first;
        final acc = _budgetRepository.getAccountById(transaction.accountId!);
        trTiles.add(transaction.toTile(
            account: acc, category: cat, subcategory: subcategory));
      } else {
        final transfer = tr as Transfer;
        trTiles.addAll(transfer.toTiles(
            fromAccount:
                _budgetRepository.getAccountById(transfer.fromAccountId),
            toAccount: _budgetRepository.getAccountById(transfer.toAccountId)));
      }
    });

    trTiles.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    emit(state.copyWith(
        status: HomeStatus.success,
        summaryList: _switchSummaries(trTiles),
        transactionTiles: trTiles,
        transactions: transactions));
  }

  List<SummaryTile> _switchSummaries(
          [List<TransactionTile>? transactionTiles]) =>
      switch (state.tab) {
        HomeTab.accounts => _getSummariesByAccounts(
            transactionTiles: transactionTiles ?? state.transactionTiles),
        HomeTab.expenses => _getSummariesByCategory(
            transactionTiles: (transactionTiles ?? state.transactionTiles)
                .where((tr) => tr.type == TransactionType.EXPENSE)
                .toList()),
        HomeTab.income => _getSummariesByCategory(
            transactionTiles: (transactionTiles ?? state.transactionTiles)
                .where((tr) => tr.type == TransactionType.INCOME)
                .toList()),
      };

  List<SummaryTile> _getSummariesByCategory(
      {required List<TransactionTile> transactionTiles}) {
    List<SummaryTile> summaries = [];
    final transactions =
        transactionTiles.where((tr) => tr.toAccount == null).toList();
    final groupedTrByCat =
        groupBy(transactions, (TransactionTile tr) => tr.category!);

    groupedTrByCat.forEach((key, value) {
      final double sum = value.fold<double>(
          0.0, (previousValue, element) => previousValue + element.amount);

      summaries.add(SummaryTile(
          id: key.id,
          name: key.name,
          total: sum,
          transactionTiles: value,
          iconCodePoint: key.iconCode));
    });
    return summaries;
  }

  List<SummaryTile> _getSummariesByAccounts(
      {required List<TransactionTile> transactionTiles}) {
    List<SummaryTile> summaries = [];

    _budgetRepository.getAccounts().forEach((acc) {
      summaries.add(SummaryTile(
          id: acc.id,
          name: acc.name,
          total: acc.balance,
          transactionTiles: transactionTiles
              .where((tr) =>
                  (tr.fromAccount!.id == acc.id &&
                      tr.type != TransactionType.TRANSFER) ||
                  (tr.toAccount?.id == acc.id && tr.title == 'Transfer in') ||
                  (tr.fromAccount?.id == acc.id && tr.title == 'Transfer out'))
              .toList(),
          iconCodePoint:
              _budgetRepository.getCategoryById(acc.categoryId).iconCode));
    });

    return summaries;
  }

  Future<void> setTab(int tabIndex) async {
    emit(state.copyWith(
        status: HomeStatus.loading, tab: HomeTab.values[tabIndex]));
    emit(state.copyWith(
        status: HomeStatus.success, summaryList: _switchSummaries()));
  }

  Future<void> changeDate(DateTime dateTime) async {
    emit(state.copyWith(status: HomeStatus.loading, selectedDate: dateTime));
    _transactionsRepository.fetchTransactions(dateTime);
  }

  Future<void> changeExpanded(int index) async {
    var summaryList = [...state.summaryList];
    summaryList[index] =
        summaryList[index].copyWith(isExpanded: !summaryList[index].isExpanded);
    emit(state.copyWith(summaryList: summaryList));
  }

  Future<void> deleteTransaction(
      {required TransactionTile transactionTile}) async {
    await _transactionsRepository.deleteTransactionOrTransfer(
        transaction: transactionTile);
    final lastDeleted =
        state.transactions.where((tr) => tr.getId == transactionTile.id).first;
    final newSummary = _getSummariesByCategory(
        transactionTiles: state.transactionTiles
            .where((trT) => trT.id != transactionTile.id)
            .toList());
    transactionTile.type == TransactionType.TRANSFER
        ? _updateBudgetOnDeleteTransfer(transaction: transactionTile)
        : _updateBudgetOnDeleteTransaction(transaction: transactionTile);
    emit(state.copyWith(
        summaryList: newSummary, lastDeletedTransaction: () => lastDeleted));
  }

  Future<void> undoDelete() async {
    if (state.lastDeletedTransaction!.isTransaction()) {
      await _transactionsRepository
          .createTransaction(state.lastDeletedTransaction! as Transaction);
      _updateBudgetOnUndoDeleteTransaction(
          transaction: state.lastDeletedTransaction! as Transaction);
    } else {
      await _transactionsRepository
          .createTransfer(state.lastDeletedTransaction! as Transfer);
      _updateBudgetOnUndoDeleteTransfer(
          transfer: state.lastDeletedTransaction! as Transfer);
    }
    emit(state.copyWith(
      lastDeletedTransaction: () => null,
    ));
  }

  void _updateBudgetOnDeleteTransaction(
      {required TransactionTile transaction}) {
    final accounts = _budgetRepository.getAccounts();
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

  void _updateBudgetOnDeleteTransfer({required TransactionTile transaction}) {
    List<Account> updatedAccounts = [];
    final accounts = _budgetRepository.getAccounts();
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
      {required Transaction transaction, TransactionTile? editedTransaction}) {
    final accounts = _budgetRepository.getAccounts();
    var updatedAccounts = [...accounts];
    updatedAccounts = updatedAccounts.map((acc) {
      if (acc.id == transaction.accountId) {
        return acc.copyWith(
            balance: acc.balance +
                (transaction.type == TransactionType.EXPENSE
                    ? -transaction.amount!
                    : transaction.amount!));
      } else {
        return acc;
      }
    }).toList();

    _budgetRepository.pushUpdatedAccounts(updatedAccounts);
  }

  void _updateBudgetOnUndoDeleteTransfer({required Transfer transfer}) {
    final accounts = _budgetRepository.getAccounts();
    List<Account> updatedAccounts = [];

    //find the acc from editedTransaction and return amount
    //find the acc from transaction and update amount
    updatedAccounts = accounts.map((acc) {
      if (acc.id == transfer.fromAccountId) {
        return acc.copyWith(balance: acc.balance - transfer.amount);
      } else {
        return acc;
      }
    }).toList();
    updatedAccounts = updatedAccounts.map((acc) {
      if (acc.id == transfer.toAccountId) {
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
    _transactionsSubscription.cancel();
    _budgetSubscription.cancel();
    return super.close();
  }
}
