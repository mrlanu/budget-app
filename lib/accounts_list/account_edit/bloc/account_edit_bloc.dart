import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:budget_app/accounts_list/account_edit/model/account_with_details.dart';
import 'package:budget_app/accounts_list/repository/account_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

import '../../../categories/repository/category_repository.dart';
import '../../../database/database.dart';

part 'account_edit_event.dart';
part 'account_edit_state.dart';

class AccountEditBloc extends Bloc<AccountEditEvent, AccountEditState> {
  final AccountRepository _accountRepository;
  final CategoryRepository _categoryRepository;
  late final StreamSubscription<List<AccountWithDetails>> _accountSubscription;
  late final StreamSubscription<List<Category>> _accountCategoriesSubscription;

  AccountEditBloc({required AccountRepository accountRepository, required CategoryRepository categoryRepository})
      : _accountRepository = accountRepository, _categoryRepository = categoryRepository,
        super(AccountEditState()) {
    on<AccountEditEvent>(_onEvent, transformer: sequential());
    _accountSubscription = _accountRepository.accounts.listen((accounts) {
      add(AccountsChanged(accounts: accounts));
    });
    _accountCategoriesSubscription = _categoryRepository.categories.listen((categories) {
      add(AccountCategoriesChanged(categories: categories));
    });
  }

  Future<void> _onEvent(
      AccountEditEvent event, Emitter<AccountEditState> emit) async {
    return switch (event) {
      final AccountEditFormLoaded e => _onFormLoaded(e, emit),
      final AccountNameChanged e => _onNameChanged(e, emit),
      final AccountsChanged e => _onAccountsChanged(e, emit),
      final AccountCategoryChanged e => _onCategoryChanged(e, emit),
      final AccountCategoriesChanged e => _onCategoriesChanged(e, emit),
      final AccountBalanceChanged e => _onBalanceChanged(e, emit),
      final AccountIncludeInTotalsChanged e =>
        _onIncludeInTotalsChanged(e, emit),
      final AccountFormSubmitted e => _onFormSubmitted(e, emit),
    };
  }

  Future<void> _onFormLoaded(
      AccountEditFormLoaded event, Emitter<AccountEditState> emit) async {
    if (event.account != null) {
      final account = event.account!;
      emit(state.copyWith(
          id: account.id,
          category: account.category,
          name: account.name,
          balance: Amount.dirty(account.balance.toString()),
          isIncludeInTotals: account.includeInTotal,
          accStatus: AccountEditStatus.success,
          isValid: true));
    } else {
      emit(state.copyWith(
          accStatus: AccountEditStatus.success));
    }
  }

  void _onNameChanged(
      AccountNameChanged event, Emitter<AccountEditState> emit) {
    emit(
      state.copyWith(name: event.name),
    );
  }

  void _onAccountsChanged(
      AccountsChanged event, Emitter<AccountEditState> emit) {
    emit(state.copyWith());
  }

  void _onCategoryChanged(
      AccountCategoryChanged event, Emitter<AccountEditState> emit) {
    emit(state.copyWith(category: event.category));
  }

  void _onCategoriesChanged(
      AccountCategoriesChanged event, Emitter<AccountEditState> emit) {
    emit(state.copyWith(categories: event.categories));
  }

  void _onBalanceChanged(
      AccountBalanceChanged event, Emitter<AccountEditState> emit) {
    final balance = Amount.dirty(event.balance!);
    emit(
      state.copyWith(
        balance: balance,
        isValid: Formz.validate([balance]),
      ),
    );
  }

  void _onIncludeInTotalsChanged(
      AccountIncludeInTotalsChanged event, Emitter<AccountEditState> emit) {
    emit(state.copyWith(isIncludeInTotals: event.value));
  }

  Future<void> _onFormSubmitted(
      AccountFormSubmitted event, Emitter<AccountEditState> emit) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final isIdExist = state.id != null;
    final account = Account(
        id: isIdExist ? state.id! : -1,
        name: state.name!,
        categoryId: state.category!.id,
        balance: double.parse(state.balance.value),
        initialBalance: double.parse(state.balance.value),
        includeInTotal: state.isIncludeInTotals);
    isIdExist
        ? _accountRepository.updateAccount(account)
        : _accountRepository.createAccount(account);
  }

  @override
  Future<void> close() {
    _accountSubscription.cancel();
    _accountCategoriesSubscription.cancel();
    return super.close();
  }
}
