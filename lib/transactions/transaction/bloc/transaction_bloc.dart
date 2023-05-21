import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

import '../../../accounts/models/account_brief.dart';
import '../../../shared/models/budget.dart';
import '../../../shared/models/category.dart';
import '../../../shared/models/section.dart';
import '../../../shared/models/subcategory.dart';
import '../../models/transaction.dart';
import '../../models/transaction_type.dart';
import '../../repository/transactions_repository.dart';

part 'transaction_event.dart';

part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final Budget _budget;
  final TransactionsRepository _transactionsRepository;

  TransactionBloc(
      {required Budget budget,
      required TransactionsRepository transactionsRepository,
      required String? transactionId})
      : _budget = budget,
        _transactionsRepository = transactionsRepository,
        super(transactionId == null
            ? TransactionState.initial()
            : TransactionState.loading()) {
    on<TransactionEvent>(_onEvent, transformer: sequential());
    if (transactionId == null) {
      add(TransactionFormLoaded());
    } else {
      add(TransactionFormFetchRequested(transactionId: transactionId));
    }
  }

  Future<void> _onEvent(
      TransactionEvent event, Emitter<TransactionState> emit) async {
    return switch (event) {
      final TransactionFormLoaded e => _onFormLoaded(e, emit),
      final TransactionFormFetchRequested e => _fetchTransaction(e, emit),
      final TransactionCategoryChanged e => _onCategoryChanged(e, emit),
      final TransactionSubcategoryChanged e => _onSubcategoryChanged(e, emit),
      final TransactionAmountChanged e => _onAmountChanged(e, emit),
      final TransactionDateChanged e => _onDateChanged(e, emit),
      final TransactionNotesChanged e => _onNotesChanged(e, emit),
      final TransactionAccountChanged e => _onAccountChanged(e, emit),
      final TransactionFormSubmitted e => _onFormSubmitted(e, emit),
    };
  }

  void _onFormLoaded(
    TransactionFormLoaded event,
    Emitter<TransactionState> emit,
  ) async {
    final categories = _filterCategories();
    final accounts = _getAccounts();
    emit(state.copyWith(categories: categories, accounts: accounts));
  }

  List<Category> _filterCategories() {
    return _budget.categoryList
        .where((cat) => cat.section == Section.EXPENSES)
        .toList();
  }

  List<AccountBrief> _getAccounts() {
    return _budget.accountBriefList;
  }

  void _onCategoryChanged(
      TransactionCategoryChanged event, Emitter<TransactionState> emit) async {
    emit(TransactionState.subcategoriesLoadInProgress(
        transactionId: state.transactionId,
        amount: state.amount,
        dateTime: state.date,
        categories: state.categories,
        category: event.category,
        accounts: state.accounts,
        account: state.account,
        status: state.status,
        isValid: state.isValid));
    final subcategories = _budget.subcategoryList
        .where((cat) => cat.categoryId == event.category!.id)
        .toList();
    emit(
        state.copyWith(category: state.category, subcategories: subcategories));
  }

  void _onSubcategoryChanged(
      TransactionSubcategoryChanged event, Emitter<TransactionState> emit) {
    emit(state.copyWith(subcategory: event.subcategory));
  }

  void _onAccountChanged(
      TransactionAccountChanged event, Emitter<TransactionState> emit) {
    emit(state.copyWith(account: event.account));
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

  void _onNotesChanged(
      TransactionNotesChanged event, Emitter<TransactionState> emit) {
    emit(state.copyWith(notes: event.notes));
  }

  Future<void> _onFormSubmitted(
      TransactionFormSubmitted event, Emitter<TransactionState> emit) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final transaction = Transaction(
      id: state.transactionId,
      budgetId: _budget.id,
      date: state.date ?? DateTime.now(),
      type: state.transactionType,
      amount: double.parse(state.amount.value),
      categoryId: state.category!.id,
      subcategoryId: state.subcategory!.id,
      accountId: state.account!.id,
    );
    try {
      await _transactionsRepository.createTransaction(transaction);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
      Navigator.of(event.context!).pop();
    } catch (e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  Future<void> _fetchTransaction(TransactionFormFetchRequested event,
      Emitter<TransactionState> emit) async {
    emit(TransactionState.loading());
    final tr =
        await _transactionsRepository.fetchTransactionById(event.transactionId);
    final category = _filterCategories()
        .where((element) => element.id == tr.categoryId)
        .first;
    final subcategories = _budget.subcategoryList
        .where((sCat) => sCat.categoryId == category.id)
        .toList();
    final subcategory =
        subcategories.where((element) => element.id == tr.subcategoryId).first;
    final accounts = _getAccounts();
    final account =
        accounts.where((element) => element.id == tr.accountId).first;
    emit(TransactionState.edit(
        transactionId: tr.id,
        amount: tr.amount.toString(),
        dateTime: tr.date,
        categories: _filterCategories(),
        category: category,
        subcategories: subcategories,
        subcategory: subcategory,
        notes: tr.description,
        accounts: accounts,
        accountBrief: account));
  }
}