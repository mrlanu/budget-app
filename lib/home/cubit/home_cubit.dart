import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:budget_app/transactions/repository/transactions_repository.dart';
import "package:collection/collection.dart";
import 'package:equatable/equatable.dart';

import '../../budgets/budgets.dart';
import '../../transactions/models/transaction.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final BudgetRepository _budgetRepository;
  final TransactionsRepository _transactionsRepository;
  late final StreamSubscription<List<Transaction>> _transactionsSubscription;
  late final StreamSubscription<Budget> _budgetsSubscription;

  HomeCubit({
    required BudgetRepository budgetRepository,
    required TransactionsRepository transactionsRepository,
  })  : _budgetRepository = budgetRepository,
        _transactionsRepository = transactionsRepository,
        super(HomeState(selectedDate: DateTime.now())) {
    _init();
  }

  Future<void> _init() async {
    emit(state.copyWith(status: HomeStatus.loading));
    _budgetsSubscription = _budgetRepository.budget.listen((budget) {
      final sections = _recalculateSections(accounts: budget.accountList);
      emit(state.copyWith(sectionsSum: sections));
    }, onError: (err) {
      emit(state.copyWith(
          status: HomeStatus.failure,
          errorMessage: 'HomeCubit. Something went wrong'));
    });
    _transactionsSubscription =
        _transactionsRepository.transactions.listen((transactions) {
      _onTransactionsChanged(transactions);
    });
    try {} catch (e) {
      emit(state.copyWith(
          status: HomeStatus.failure, errorMessage: 'Something went wrong'));
    }
  }

  Future<void> _onTransactionsChanged(List<Transaction> transactions) async {
    final sectionsSum = _recalculateSections(transactions: transactions);
    emit(state.copyWith(sectionsSum: sectionsSum));
  }

  Map<String, double> _recalculateSections({List<Transaction>? transactions, List<Account>? accounts}) {

    double expSum = state.sectionsSum['expenses']!;
    double incSum = state.sectionsSum['incomes']!;
    double accSum = state.sectionsSum['accounts']!;

    if(transactions != null) {
      final groupedTransactions = groupBy(transactions, (Transaction p0) => p0.type);
      expSum = groupedTransactions[TransactionType.EXPENSE]
          ?.fold<double>(0,
              (previousValue, element) => previousValue + element.amount!) ??
          0;
      incSum = groupedTransactions[TransactionType.INCOME]
          ?.fold<double>(0,
              (previousValue, element) => previousValue + element.amount!) ??
          0;
    }
    accSum = _budgetRepository.getAccounts()
        .where((acc) => acc.includeInTotal)
        .fold<double>(
        0.0, (previousValue, element) => previousValue + element.balance);

    return {'expenses': expSum, 'incomes': incSum, 'accounts': accSum};
  }

  Future<void> setTab(int tabIndex) async {
    emit(state.copyWith(tab: HomeTab.values[tabIndex]));
  }

  Future<void> changeDate(DateTime dateTime) async {
    emit(state.copyWith(selectedDate: dateTime));
  }

  @override
  Future<void> close() {
    _transactionsSubscription.cancel();
    _budgetsSubscription.cancel();
    return super.close();
  }
}
