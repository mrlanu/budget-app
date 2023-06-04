import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:budget_app/accounts/repository/accounts_repository.dart';
import 'package:budget_app/categories/repository/categories_repository.dart';
import 'package:budget_app/subcategories/repository/subcategories_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

import '../../../accounts/models/account.dart';
import '../../../categories/models/category.dart';
import '../../../shared/models/budget.dart';
import '../../../shared/models/subcategory.dart';
import '../../models/transaction.dart';
import '../../models/transaction_type.dart';
import '../../repository/transactions_repository.dart';

part 'transaction_event.dart';

part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final Budget _budget;
  final TransactionsRepository _transactionsRepository;
  final CategoriesRepository _categoriesRepository;
  final SubcategoriesRepository _subcategoriesRepository;
  late final AccountsRepository _accountsRepository;
  late final StreamSubscription<List<Category>> _categoriesSubscription;
  late final StreamSubscription<List<Subcategory>> _subcategoriesSubscription;
  late final StreamSubscription<List<Account>> _accountsSubscription;

  TransactionBloc({
    required Budget budget,
    required TransactionsRepository transactionsRepository,
    required CategoriesRepository categoriesRepository,
    required SubcategoriesRepository subcategoriesRepository,
    required AccountsRepository accountsRepository,
  })  : _budget = budget,
        _transactionsRepository = transactionsRepository,
        _categoriesRepository = categoriesRepository,
        _subcategoriesRepository = subcategoriesRepository,
        _accountsRepository = accountsRepository,
        super(TransactionState()) {
    on<TransactionEvent>(_onEvent, transformer: sequential());
    _categoriesSubscription =
        _categoriesRepository.getCategories().skip(1).listen((categories) {
      add(TransactionCategoriesChanged(categories: categories));
    });
    _subcategoriesSubscription = _subcategoriesRepository
        .getSubcategories()
        .skip(1)
        .listen((subcategories) {
      add(TransactionSubcategoriesChanged(subcategories: subcategories));
    });
    _accountsSubscription =
        _accountsRepository.getAccounts().skip(1).listen((accounts) {
      add(TransactionAccountsChanged(accounts: accounts));
    });
  }

  Future<void> _onEvent(
      TransactionEvent event, Emitter<TransactionState> emit) async {
    return switch (event) {
      final TransactionFormLoaded e => _onFormLoaded(e, emit),
      final TransactionAmountChanged e => _onAmountChanged(e, emit),
      final TransactionDateChanged e => _onDateChanged(e, emit),
      final TransactionCategoriesChanged e => _onCategoriesChanged(e, emit),
      final TransactionCategoryChanged e => _onCategoryChanged(e, emit),
      final TransactionSubcategoriesChanged e =>
        _onSubcategoriesChanged(e, emit),
      final TransactionSubcategoryChanged e => _onSubcategoryChanged(e, emit),
      final TransactionSubcategoryCreated e => _onSubcategoryCreated(e, emit),
      final TransactionAccountsChanged e => _onAccountsChanged(e, emit),
      final TransactionAccountChanged e => _onAccountChanged(e, emit),
      final TransactionNotesChanged e => _onNotesChanged(e, emit),
      final TransactionFormSubmitted e => _onFormSubmitted(e, emit),
    };
  }

  Future<void> _onFormLoaded(
    TransactionFormLoaded event,
    Emitter<TransactionState> emit,
  ) async {
    final categories = await _categoriesRepository.fetchCategories(
        budgetId: _budget.id, transactionType: event.transactionType);
    final accounts =
        await _accountsRepository.fetchAccounts(budgetId: _budget.id);
    final accCategories = await _categoriesRepository.fetchCategories(
        budgetId: _budget.id, transactionType: TransactionType.ACCOUNT);
    var subcategories = <Subcategory>[];
    var category;
    var subcategory;
    var account;
    final tr = event.transaction;
    if (tr != null) {
      category = categories.where((cat) => cat.id == tr.categoryId).first;
      subcategories = await _subcategoriesRepository.fetchSubcategories(
          budgetId: _budget.id, categoryId: category.id);
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
        accountCategories: accCategories,
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

  Future<void> _onCategoriesChanged(TransactionCategoriesChanged event,
      Emitter<TransactionState> emit) async {
    /*emit(state.resetCategory().copyWith(categories: event.categories));*/
    emit(state.copyWith(categories: event.categories));
  }

  void _onCategoryChanged(
      TransactionCategoryChanged event, Emitter<TransactionState> emit) async {
    emit(state.resetSubcategories());
    final subcategories = await _subcategoriesRepository.fetchSubcategories(
        budgetId: _budget.id, categoryId: event.category!.id!);
    emit(
        state.copyWith(category: event.category, subcategories: subcategories));
  }

  Future<void> _onSubcategoriesChanged(TransactionSubcategoriesChanged event,
      Emitter<TransactionState> emit) async {
    /*emit(state.resetSubcategory().copyWith(subcategories: event.subcategories));*/
    emit(state.copyWith(subcategories: event.subcategories));
  }

  void _onSubcategoryChanged(
      TransactionSubcategoryChanged event, Emitter<TransactionState> emit) {
    emit(state.copyWith(subcategory: event.subcategory));
  }

  void _onSubcategoryCreated(
      TransactionSubcategoryCreated event, Emitter<TransactionState> emit) {
    final newSubcategory = Subcategory(
      categoryId: state.category!.id!,
      name: event.name,
      budgetId: _budget.id,
    );
    _subcategoriesRepository.saveSubcategory(
        budgetId: _budget.id, subcategory: newSubcategory);
  }

  void _onAccountsChanged(
      TransactionAccountsChanged event, Emitter<TransactionState> emit) {
    emit(state.copyWith(accounts: event.accounts));
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

  @override
  Future<void> close() {
    _categoriesSubscription.cancel();
    _subcategoriesSubscription.cancel();
    _accountsSubscription.cancel();
    return super.close();
  }
}
