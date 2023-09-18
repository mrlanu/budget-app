import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/budgets/budgets.dart';
import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/transactions/models/transaction_tile.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

import '../../models/transaction.dart';
import '../../models/transaction_type.dart';
import '../../repository/transactions_repository.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionsRepository _transactionsRepository;
  final BudgetRepository _budgetRepository;
  late final StreamSubscription<Budget> _budgetSubscription;

  TransactionBloc(
      {required TransactionsRepository transactionsRepository,
      required BudgetRepository budgetRepository})
      : _transactionsRepository = transactionsRepository,
        _budgetRepository = budgetRepository,
        super(TransactionState()) {
    on<TransactionEvent>(_onEvent, transformer: sequential());
    _budgetSubscription = _budgetRepository.budget.listen((budget) {
      add(TransactionBudgetChanged(
          categories: budget.categoryList, accounts: budget.accountList));
    });
  }

  Future<void> _onEvent(
      TransactionEvent event, Emitter<TransactionState> emit) async {
    return switch (event) {
      final TransactionFormLoaded e => _onFormLoaded(e, emit),
      final TransactionBudgetChanged e => _onBudgetChanged(e, emit),
      final TransactionAmountChanged e => _onAmountChanged(e, emit),
      final TransactionDateChanged e => _onDateChanged(e, emit),
      final TransactionCategoryChanged e => _onCategoryChanged(e, emit),
      final TransactionSubcategoryChanged e => _onSubcategoryChanged(e, emit),
      final TransactionAccountChanged e => _onAccountChanged(e, emit),
      final TransactionNotesChanged e => _onNotesChanged(e, emit),
      final TransactionFormSubmitted e => _onFormSubmitted(e, emit),
    };
  }

  Future<void> _onBudgetChanged(
    TransactionBudgetChanged event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(
        categories: () =>
            _budgetRepository.getCategoriesByType(state.transactionType),
        accounts: () => event.accounts!));
  }

  Future<void> _onFormLoaded(
    TransactionFormLoaded event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(trStatus: TransactionStatus.loading));
    Category? category;
    Subcategory? subcategory;
    Account? account;
    String? id;
    final tr = event.transaction;
    if (tr != null) {
      id = tr.id;
      category = _budgetRepository
          .getCategoriesByType(event.transactionType)
          .where((cat) => cat.id == tr.category)
          .first;
      subcategory = category.subcategoryList
          .where((element) => element.name == tr.subcategory)
          .first;
      account = _budgetRepository.getAccountById(tr.fromAccount!.id);
    }
    //for amount update on desktop view
    await Future.delayed(Duration(milliseconds: 100));

    emit(TransactionState(
        id: id,
        transactionType: event.transactionType,
        amount: tr == null ? Amount.pure() : Amount.dirty(tr.amount.toString()),
        date: tr?.dateTime ?? event.date,
        category: category,
        subcategory: subcategory,
        account: account,
        description: tr?.description ?? '',
        accountCategories:
            _budgetRepository.getCategoriesByType(TransactionType.ACCOUNT),
        trStatus: TransactionStatus.success,
        isValid: tr == null ? false : true));
  }

  void _onAmountChanged(
      TransactionAmountChanged event, Emitter<TransactionState> emit) {
    final amount = Amount.dirty(event.amount!);
    emit(
      state.copyWith(
        amount: amount,
        isValid: Formz.validate([amount]),
      ),
    );
  }

  void _onDateChanged(
      TransactionDateChanged event, Emitter<TransactionState> emit) {
    emit(
      state.copyWith(date: event.dateTime),
    );
  }

  void _onCategoryChanged(
      TransactionCategoryChanged event, Emitter<TransactionState> emit) async {
    emit(state.copyWith(
        category: () => event.category,
        subcategory: () => null,
        subcategories: () => event.category!.subcategoryList));
  }

  void _onSubcategoryChanged(
      TransactionSubcategoryChanged event, Emitter<TransactionState> emit) {
    emit(state.copyWith(subcategory: () => event.subcategory));
  }

  void _onAccountChanged(
      TransactionAccountChanged event, Emitter<TransactionState> emit) {
    emit(state.copyWith(account: event.account));
  }

  void _onNotesChanged(
      TransactionNotesChanged event, Emitter<TransactionState> emit) {
    emit(state.copyWith(description: event.description));
  }

  Future<void> _onFormSubmitted(
      TransactionFormSubmitted event, Emitter<TransactionState> emit) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final transaction = Transaction(
      id: state.id,
      date: state.date ?? DateTime.now(),
      type: state.transactionType,
      amount: double.parse(state.amount.value),
      categoryId: state.category?.id,
      subcategoryName: state.subcategory?.name,
      accountId: state.account!.id,
    );
    try {
      await _transactionsRepository.createTransaction(transaction);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
      isDisplayDesktop(event.context!)
          ? add(TransactionFormLoaded(
              transactionType: transaction.type!, date: transaction.date!))
          : Navigator.of(event.context!).pop();
    } catch (e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  @override
  Future<void> close() {
    _budgetSubscription.cancel();
    return super.close();
  }
}
