import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:budget_app/transaction/repository/transactions_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:isar/isar.dart';

import '../../../categories/models/category.dart';
import '../../models/account.dart';

part 'account_edit_event.dart';
part 'account_edit_state.dart';

class AccountEditBloc extends Bloc<AccountEditEvent, AccountEditState> {
  late final StreamSubscription<List<Account>> _accountsSubscription;
  late final StreamSubscription<List<Category>> _categoriesSubscription;
  final TransactionsRepository _transactionsRepository;

  AccountEditBloc({required TransactionsRepository transactionsRepository})
      : _transactionsRepository = transactionsRepository,
        super(AccountEditState()) {
    on<AccountEditEvent>(_onEvent, transformer: sequential());
    _accountsSubscription = _transactionsRepository.accounts.listen((accounts) {
      add(AccountAccountsChanged(accounts: accounts));
    });
    _categoriesSubscription =
        _transactionsRepository.categories.listen((categories) {
      add(AccountCategoriesChanged(categories: categories));
    });
  }

  Future<void> _onEvent(
      AccountEditEvent event, Emitter<AccountEditState> emit) async {
    return switch (event) {
      final AccountEditFormLoaded e => _onFormLoaded(e, emit),
      final AccountNameChanged e => _onNameChanged(e, emit),
      final AccountAccountsChanged e => _onAccountsChanged(e, emit),
      final AccountCategoriesChanged e => _onCategoriesChanged(e, emit),
      final AccountCategoryChanged e => _onCategoryChanged(e, emit),
      final AccountBalanceChanged e => _onBalanceChanged(e, emit),
      final AccountIncludeInTotalsChanged e =>
        _onIncludeInTotalsChanged(e, emit),
      final AccountFormSubmitted e => _onFormSubmitted(e, emit),
    };
  }

  Future<void> _onFormLoaded(
      AccountEditFormLoaded event, Emitter<AccountEditState> emit) async {
    if (event.account != null) {
      Account account = event.account!;
      emit(state.copyWith(
          id: account.id,
          category: account.category.value,
          name: account.name,
          balance: Amount.dirty(account.balance.toString()),
          isIncludeInTotals: account.includeInTotal,
          accStatus: AccountEditStatus.success,
          isValid: true));
    } else {
      emit(state.copyWith(accStatus: AccountEditStatus.success));
    }
  }

  void _onNameChanged(
      AccountNameChanged event, Emitter<AccountEditState> emit) {
    emit(
      state.copyWith(name: event.name),
    );
  }

  void _onAccountsChanged(
      AccountAccountsChanged event, Emitter<AccountEditState> emit) {
    emit(state.copyWith(accounts: event.accounts));
  }

  void _onCategoriesChanged(
      AccountCategoriesChanged event, Emitter<AccountEditState> emit) {
    emit(state.copyWith(categories: event.categories));
  }

  void _onCategoryChanged(
      AccountCategoryChanged event, Emitter<AccountEditState> emit) {
    emit(state.copyWith(category: event.category));
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
        id: isIdExist ? state.id! : Isar.autoIncrement,
        name: state.name!,
        balance: double.parse(state.balance.value),
        initialBalance: double.parse(state.balance.value),
        includeInTotal: state.isIncludeInTotals)
      ..category.value = state.category;
    isIdExist
        ? _transactionsRepository.updateAccount(account)
        : _transactionsRepository.createAccount(account);
  }

  @override
  Future<void> close() {
    _accountsSubscription.cancel();
    return super.close();
  }
}
