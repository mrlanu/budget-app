import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/accounts/models/account.dart';
import 'package:budget_app/accounts/repository/accounts_repository.dart';
import 'package:equatable/equatable.dart';

import '../../categories/models/category.dart';

part 'accounts_list_state.dart';

class AccountsListCubit extends Cubit<AccountsListState> {
  final AccountsRepository _accountsRepository;
  late final StreamSubscription<List<Account>> _accountsSubscription;

  AccountsListCubit(
      {required AccountsRepository accountsRepository, required List<Category> accountCategories})
      : _accountsRepository = accountsRepository,
        super(AccountsListState(accountCategories: accountCategories)){
    _accountsSubscription =
        _accountsRepository.getAccounts().listen((accounts) {
          _onAccountsChanged(accounts);
        });
  }

  Future<void> onInit({required String budgetId}) async {
    final accounts = await _accountsRepository.fetchAccounts(budgetId: budgetId);
    emit(state.copyWith(
        status: AccountsListStatus.success, accounts: accounts));
  }

  void _onAccountsChanged(List<Account> accounts){
    emit(state.copyWith(accounts: accounts));
  }

  /*void onNewCategory() {
    emit(state.resetCategory());
  }*/

  void onAccountEdit(Account account) {
    emit(state.copyWith(editedAccount: account));
  }

  void onSubmit(String budgetId) {
    var account;
    if (state.editedAccount == null) {
      //category = Category(name: state.name!, budgetId: budgetId, transactionType: state.transactionType);
    } else {
      //category = state.editCategory!.copyWith(name: state.name);
    }
    _accountsRepository.saveAccount(account: account);
  }

  void onAccountDeleted(Account account){
    _accountsRepository.deleteAccount(account: account);
  }

  @override
  Future<void> close() {
    _accountsSubscription.cancel();
    return super.close();
  }
}
