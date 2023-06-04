import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/accounts/repository/accounts_repository.dart';
import 'package:budget_app/shared/models/budget.dart';
import 'package:budget_app/shared/models/summary_by.dart';
import 'package:budget_app/transactions/repository/transactions_repository.dart';
import 'package:equatable/equatable.dart';

import '../../accounts/models/account.dart';
import '../../shared/repositories/shared_repository.dart';
import '../../transactions/models/transaction.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final TransactionsRepository _transactionsRepository;
  final AccountsRepository _accountsRepository;
  late final StreamSubscription<List<Transaction>> _transactionsSubscription;
  late final StreamSubscription<List<Account>> _accountsSubscription;
  final SharedRepository _sharedRepository;
  final String budgetId;

  HomeCubit(
      {required TransactionsRepository transactionsRepository,
      required SharedRepository sharedRepository,
      required AccountsRepository accountsRepository,
      required this.budgetId})
      : this._transactionsRepository = transactionsRepository,
        this._accountsRepository = accountsRepository,
        this._sharedRepository = sharedRepository,
        super(HomeState(selectedDate: DateTime.now()));

  Future<void> init() async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      _transactionsSubscription = _transactionsRepository.getTransactions().listen(
        (_) {
          fetchHomePageData(
              budgetId: budgetId,
              section: state.tab.name,
              dateTime: state.selectedDate ?? DateTime.now());
        },
      );
      _accountsSubscription = _accountsRepository.getAccounts().listen((_) {
        fetchHomePageData(
            budgetId: budgetId,
            section: state.tab.name,
            dateTime: state.selectedDate ?? DateTime.now());
      });
      emit(state.copyWith(
        status: HomeStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: HomeStatus.failure,
          errorMessage: 'Fetching budget error. ${e.toString()}'));
    }
  }

  void setTab(int tabIndex) {
    emit(state.copyWith(tab: HomeTab.values[tabIndex]));
    fetchHomePageData(
        budgetId: budgetId,
        section: state.tab.name,
        dateTime: state.selectedDate ?? DateTime.now());
  }

  void dateChanged(DateTime dateTime) {
    fetchHomePageData(
        budgetId: budgetId, section: state.tab.name, dateTime: dateTime);
  }

  Future<void> fetchHomePageData(
      {required String budgetId,
      required String section,
      required DateTime dateTime}) async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      final sections = await _fetchAllSections(budgetId, dateTime);
      final summaryList = await _fetchSummaryList(
          budgetId: budgetId, section: section, dateTime: dateTime);
      emit(state.copyWith(
          status: HomeStatus.success,
          sectionSummary: sections,
          summaryList: summaryList,
          selectedDate: dateTime));
    } catch (e) {
      emit(state.copyWith(
          status: HomeStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<Map<String, double>> _fetchAllSections(
      String budgetId, DateTime dateTime) async {
    return await _sharedRepository.fetchAllSections(budgetId, dateTime);
  }

  Future<List<SummaryBy>> _fetchSummaryList(
      {required String budgetId,
      required String section,
      required DateTime dateTime}) async {
    return await _sharedRepository.fetchSummaryList(
        budgetId: budgetId, section: section, dateTime: dateTime);
  }

  @override
  Future<void> close() {
    _transactionsSubscription.cancel();
    _accountsSubscription.cancel();
    return super.close();
  }
}
