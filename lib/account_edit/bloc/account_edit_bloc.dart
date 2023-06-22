import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:budget_app/accounts/models/account.dart';
import 'package:budget_app/accounts/repository/accounts_repository.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

import '../../categories/models/category.dart';
import '../../categories/repository/categories_repository.dart';

part 'account_edit_event.dart';

part 'account_edit_state.dart';

class AccountEditBloc extends Bloc<AccountEditEvent, AccountEditState> {
  final String budgetId;
  final CategoriesRepository _categoriesRepository;
  final AccountsRepository _accountsRepository;
  late final StreamSubscription<List<Category>> _categoriesSubscription;

  AccountEditBloc(
      {required this.budgetId,
      required CategoriesRepository categoriesRepository,
      required AccountsRepository accountsRepository})
      : _categoriesRepository = categoriesRepository,
        _accountsRepository = accountsRepository,
        super(AccountEditState()) {
    on<AccountEditEvent>(_onEvent, transformer: sequential());
    _categoriesSubscription =
        _categoriesRepository.getCategories().skip(1).listen((categories) {
      add(AccountCategoriesChanged(categories: categories));
    });
  }

  Future<void> _onEvent(
      AccountEditEvent event, Emitter<AccountEditState> emit) async {
    return switch (event) {
      final AccountEditFormLoaded e => _onFormLoaded(e, emit),
      final AccountNameChanged e => _onNameChanged(e, emit),
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
    final categories = await _categoriesRepository.getCategories().first;
    final filteredCategories = categories
        .where((cat) => cat.transactionType == TransactionType.ACCOUNT)
        .toList();
    if (event.account != null) {
      final account = event.account;
      final category = filteredCategories
          .where((element) => element.id == account!.categoryId)
          .first;
      emit(state.copyWith(
          id: account!.id,
          category: category,
          categories: filteredCategories,
          name: account.name,
          balance: Amount.dirty(account.balance.toString()),
          isIncludeInTotals: account.includeInTotal,
          accStatus: AccountEditStatus.success,
          isValid: true));
    } else {
      emit(state.copyWith(
          categories: filteredCategories, accStatus: AccountEditStatus.success));
    }
  }

  void _onNameChanged(
      AccountNameChanged event, Emitter<AccountEditState> emit) {
    emit(
      state.copyWith(name: event.name),
    );
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
    final account = Account(
        id: state.id,
        name: state.name!,
        categoryId: state.category!.id!,
        balance: double.parse(state.balance.value),
        initialBalance: double.parse(state.balance.value),
        includeInTotal: state.isIncludeInTotals,
        budgetId: budgetId);
    _accountsRepository.saveAccount(account: account);
    Navigator.of(event.context).pop();
  }

  @override
  Future<void> close() {
    _categoriesSubscription.cancel();
    return super.close();
  }
}
