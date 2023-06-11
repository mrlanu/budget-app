import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/shared/shared.dart';
import 'package:budget_app/transactions/models/transaction.dart';
import 'package:equatable/equatable.dart';

import '../../transactions/repository/transactions_repository.dart';
import '../models/account.dart';
import '../repository/accounts_repository.dart';

part 'accounts_state.dart';

class AccountsCubit extends Cubit<AccountsState> {
  final AccountsRepository _accountsRepository;
  final TransactionsRepository _transactionsRepository;
  late final StreamSubscription<List<Transaction>> _transactionsSubscription;

  AccountsCubit(
      {required String budgetId, required String categoryId, required AccountsRepository accountsRepository,
        required TransactionsRepository transactionsRepository})
      : _accountsRepository = accountsRepository,
        _transactionsRepository = transactionsRepository,
        super(AccountsState(budgetId: budgetId, categoryId: categoryId)) {
    _transactionsSubscription = _transactionsRepository
        .getTransactions()
        .skip(1)
        .listen((transactions) {
      fetchAllAccounts();
    });
  }

  Future<void> fetchAllAccounts() async {
    try {
      final accountList = await _accountsRepository.fetchAccounts(
          budgetId: state.budgetId, categoryId: state.categoryId);
      emit(
          state.copyWith(status: DataStatus.success, accountList: accountList));
    } catch (e) {
      emit(
          state.copyWith(status: DataStatus.error, errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _transactionsSubscription.cancel();
    return super.close();
  }
}
