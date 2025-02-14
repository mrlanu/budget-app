import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/accounts_list/account_edit/model/account_with_details.dart';
import 'package:budget_app/accounts_list/repository/account_repository.dart';
import 'package:equatable/equatable.dart';

import '../../categories/repository/category_repository.dart';
import '../../database/database.dart';
import '../../transaction/models/transaction_type.dart';

part 'accounts_state.dart';

class AccountsCubit extends Cubit<AccountsState> {
  final AccountRepository _accountRepository;
  final CategoryRepository _categoryRepository;
  late final StreamSubscription<List<AccountWithDetails>> _accountsSubscription;
  late final StreamSubscription<List<Category>> _categoriesSubscription;

  AccountsCubit(
      {required AccountRepository accountRepository,
      required CategoryRepository categoryRepository})
      : _accountRepository = accountRepository, _categoryRepository = categoryRepository,
        super(AccountsState()) {
    _accountsSubscription = _accountRepository.accounts.listen((accounts) {
      accountsChanged(accounts);
    });
    _categoriesSubscription = _categoryRepository.categories.listen((categories) {
      categoriesChanged(categories);
    });
  }

  Future<void> accountsChanged(List<AccountWithDetails> accounts) async {
    emit(state.copyWith(
        status: AccountsStatus.success,
        accountList: accounts,));
  }

  Future<void> categoriesChanged(List<Category> categories) async {
    emit(state.copyWith(
        status: AccountsStatus.success,
        accountCategories: categories
            .where((cat) => cat.type == TransactionType.ACCOUNT)
            .toList()));
  }

  Future<void> onAccountDeleted(AccountWithDetails account) async {
    emit(state.copyWith(status: AccountsStatus.loading));
    /*try {
      await _accountsRepository.deleteAccount(account: account);
    } on AccountFailure catch (e) {
      emit(state.copyWith(
          status: AccountsListStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
          status: AccountsListStatus.failure, errorMessage: 'Unknown error'));
    }*/
  }

  @override
  Future<void> close() {
    _accountsSubscription.cancel();
    _categoriesSubscription.cancel();
    return super.close();
  }
}
