import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/accounts/models/accounts_view_filter.dart';
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
  late final StreamSubscription<List<Account>> _accountsSubscription;

  AccountsCubit(
      {required AccountsViewFilter filter, required AccountsRepository accountsRepository,
        required TransactionsRepository transactionsRepository})
      : _accountsRepository = accountsRepository,
        _transactionsRepository = transactionsRepository,
        super(AccountsState(filter: filter)) {
    _transactionsSubscription = _transactionsRepository
        .getTransactions()
        .skip(1)
        .listen((transactions) {
      fetchAllAccounts();
    });
    _accountsSubscription = _accountsRepository
        .getAccounts()
        .listen((accounts) {
      fetchAllAccounts();
    });
  }

  Future<void> fetchAllAccounts() async {
    emit(
        state.copyWith(status: DataStatus.loading));
    try {
      final accountList = await _accountsRepository.getAccounts().first;
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
    _accountsSubscription.cancel();
    return super.close();
  }
}
