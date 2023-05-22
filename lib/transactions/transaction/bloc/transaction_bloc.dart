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

  TransactionBloc({
    required Budget budget,
    required TransactionsRepository transactionsRepository,
  })  : _budget = budget,
        _transactionsRepository = transactionsRepository,
        super(TransactionState()) {
    on<TransactionEvent>(_onEvent, transformer: sequential());
  }

  Future<void> _onEvent(
      TransactionEvent event, Emitter<TransactionState> emit) async {
    return switch (event) {
      final TransactionFormLoaded e => _onFormLoaded(e, emit),
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
    final categories =
        _filterCategories(transactionType: event.transactionType);
    final accounts = _getAccounts();
    var subcategories = <Subcategory>[];
    var category;
    var subcategory;
    var account;
    final tr = event.transaction;
    if (tr != null) {
      category = categories.where((cat) => cat.id == tr.categoryId).first;
      subcategories = _budget.subcategoryList
          .where((sCat) => sCat.categoryId == category.id)
          .toList();
      subcategory = subcategories
          .where((element) => element.id == tr.subcategoryId)
          .first;
      account = accounts.where((element) => element.id == tr.accountId).first;
    }
    emit(TransactionState(
        transactionType: event.transactionType,
        isEdit: tr != null,
        trStatus: TransactionStatus.success,
        date: tr?.date ?? DateTime.now(),
        amount: tr == null ? Amount.pure() : Amount.dirty(tr.amount.toString()),
        categories: categories,
        category: category,
        subcategories: subcategories,
        subcategory: subcategory,
        description: tr?.description ?? '',
        accounts: accounts,
        account: account,
        transaction: tr,
        isValid: tr == null ? false : true));
  }

  List<Category> _filterCategories({required TransactionType transactionType}) {
    final section = switch (transactionType) {
      TransactionType.INCOME => Section.INCOME,
      TransactionType.EXPENSE => Section.EXPENSES,
      TransactionType.TRANSFER => Section.ACCOUNTS,
    };
    return _budget.categoryList.where((cat) => cat.section == section).toList();
  }

  List<AccountBrief> _getAccounts() {
    return _budget.accountBriefList;
  }

  void _onCategoryChanged(
      TransactionCategoryChanged event, Emitter<TransactionState> emit) async {
    emit(state.resetSubcategories());
    final subcategories = _budget.subcategoryList
        .where((cat) => cat.categoryId == event.category!.id)
        .toList();
    emit(
        state.copyWith(category: event.category, subcategories: subcategories));
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
    emit(state.copyWith(description: event.description));
  }

  Future<void> _onFormSubmitted(
      TransactionFormSubmitted event, Emitter<TransactionState> emit) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final transaction = Transaction(
        id: state.transaction?.id ?? null,
        budgetId: _budget.id,
        date: state.date ?? DateTime.now(),
        type: state.transactionType,
        amount: double.parse(state.amount.value),
        categoryId: state.category!.id,
        categoryName: state.category!.name,
        subcategoryId: state.subcategory!.id,
        subcategoryName: state.subcategory!.name,
        accountId: state.account!.id,
        accountName: state.account!.name);
    try {
      await _transactionsRepository.createTransaction(transaction);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
      Navigator.of(event.context!).pop();
    } catch (e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
