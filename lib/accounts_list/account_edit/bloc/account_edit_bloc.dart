import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/budgets/budgets.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:uuid/uuid.dart';

part 'account_edit_event.dart';
part 'account_edit_state.dart';

class AccountEditBloc extends Bloc<AccountEditEvent, AccountEditState> {
  final BudgetRepository _budgetRepository;
  late final StreamSubscription<Budget> _budgetSubscription;

  AccountEditBloc({required BudgetRepository budgetRepository})
      : _budgetRepository = budgetRepository,
        super(AccountEditState()) {
    on<AccountEditEvent>(_onEvent, transformer: sequential());
    _budgetSubscription = _budgetRepository.budget.listen((budget) {
      add(AccountBudgetChanged(budget: budget));
    });
  }

  Future<void> _onEvent(
      AccountEditEvent event, Emitter<AccountEditState> emit) async {
    return switch (event) {
      final AccountEditFormLoaded e => _onFormLoaded(e, emit),
      final AccountNameChanged e => _onNameChanged(e, emit),
      final AccountBudgetChanged e => _onBudgetChanged(e, emit),
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
      final category = _budgetRepository.getCategoryById(account.categoryId);
      emit(state.copyWith(
          id: account.id,
          category: category,
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

  void _onBudgetChanged(
      AccountBudgetChanged event, Emitter<AccountEditState> emit) {
    emit(state.copyWith(budget: event.budget));
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
        id: isIdExist ? state.id! : Uuid().v4(),
        name: state.name!,
        categoryId: state.category!.id,
        balance: double.parse(state.balance.value),
        initialBalance: double.parse(state.balance.value),
        includeInTotal: state.isIncludeInTotals);
    isIdExist
        ? _budgetRepository.updateAccount(account)
        : _budgetRepository.createAccount(account);
  }

  @override
  Future<void> close() {
    _budgetSubscription.cancel();
    return super.close();
  }
}
