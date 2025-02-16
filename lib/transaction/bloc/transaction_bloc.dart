import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:budget_app/accounts_list/account_edit/model/account_with_details.dart';
import 'package:budget_app/accounts_list/repository/account_repository.dart';
import 'package:budget_app/categories/repository/category_repository.dart';
import 'package:budget_app/database/database.dart';
import 'package:budget_app/transaction/models/transaction_tile.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

import '../models/transaction_type.dart';
import '../repository/transaction_repository.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _transactionsRepository;
  final CategoryRepository _categoryRepository;
  late final StreamSubscription<List<Category>> _categoriesSubscription;
  final AccountRepository _accountsRepository;
  late final StreamSubscription<List<AccountWithDetails>> _accountsSubscription;
  late final StreamSubscription<List<Subcategory>> _subcategoriesSubscription;

  TransactionBloc(
      {required TransactionRepository transactionsRepository,
      required CategoryRepository categoryRepository,
      required AccountRepository accountRepository})
      : _transactionsRepository = transactionsRepository,
        _categoryRepository = categoryRepository,
        _accountsRepository = accountRepository,
        super(TransactionState(date: DateTime.now())) {
    _categoriesSubscription =
        _categoryRepository.categories.listen((categories) {
      add(TransactionCategoriesChanged(categories: categories));
    });
    _accountsSubscription = _accountsRepository.accounts.listen((accounts) {
      add(TransactionAccountsChanged(accounts: accounts));
    });
    _subcategoriesSubscription = _categoryRepository.subcategories.listen((sc) {
      add(TransactionSubcategoriesChanged(subcategories: sc));
    });
    on<TransactionEvent>(_onEvent, transformer: sequential());
  }

  Future<void> _onEvent(
      TransactionEvent event, Emitter<TransactionState> emit) async {
    return switch (event) {
      final TransactionCategoriesChanged e => _onCategoriesChanged(e, emit),
      final TransactionSubcategoriesChanged e =>
        _onSubcategoriesChanged(e, emit),
      final TransactionAccountsChanged e => _onAccountsChanged(e, emit),
      final TransactionFormLoaded e => _onFormLoaded(e, emit),
      final TransactionAmountChanged e => _onAmountChanged(e, emit),
      final TransactionDateChanged e => _onDateChanged(e, emit),
      final TransactionCategoryChanged e => _onCategoryChanged(e, emit),
      final TransactionSubcategoryChanged e => _onSubcategoryChanged(e, emit),
      final TransactionAccountChanged e => _onAccountChanged(e, emit),
      final TransactionNotesChanged e => _onNotesChanged(e, emit),
      final TransactionFormSubmitted e => _onFormSubmitted(e, emit),
    };
  }

  Future<void> _onCategoriesChanged(
    TransactionCategoriesChanged event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(categories: event.categories));
  }

  Future<void> _onSubcategoriesChanged(
    TransactionSubcategoriesChanged event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(subcategories: event.subcategories));
  }

  Future<void> _onAccountsChanged(
    TransactionAccountsChanged event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(accounts: event.accounts));
  }

  Future<void> _onFormLoaded(
    TransactionFormLoaded event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(trStatus: TransactionStatus.loading));
    if (event.transactionId != null) {
      final tr = await _transactionsRepository
          .getTransactionById(event.transactionId!);
      final account =
          await _accountsRepository.getAccountById(tr.fromAccount.id);
      emit(state.copyWith(
          id: tr.id,
          transactionType: tr.type,
          amount: Amount.dirty(tr.amount.toString()),
          date: tr.date,
          category: () => tr.category,
          subcategory: () => tr.subcategory,
          account: account,
          description: tr.description,
          trStatus: TransactionStatus.success,
          isValid: true));
    } else {
      emit(state.copyWith(
        trStatus: TransactionStatus.success,
      ));
    }
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
    final subcategories = await _categoryRepository
        .fetchSubcategoriesByCategoryId(event.category!.id);
    emit(state.copyWith(
        category: () => event.category,
        subcategory: () => null,
        subcategories: subcategories));
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
    try {
      final isIdExist = state.id != null;
      isIdExist
          ? await _transactionsRepository.updateTransaction(
              id: state.id!,
              date: state.date!,
              type: state.transactionType,
              amount: double.parse(state.amount.value),
              categoryId: state.category!.id,
              subcategoryId: state.subcategory!.id,
              fromAccountId: state.account!.id!,
              description: state.description!)
          : await _transactionsRepository.insertTransaction(
              date: state.date!,
              type: state.transactionType,
              amount: double.parse(state.amount.value),
              categoryId: state.category!.id,
              subcategoryId: state.subcategory!.id,
              fromAccountId: state.account!.id!,
              description: state.description!);
      /*_updateBudgetOnAddOrEditTransaction(
          transaction: transaction, editedTransaction: state.editedTransaction);*/
      emit(state.copyWith(status: FormzSubmissionStatus.success));
      Navigator.of(event.context!).pop();
    } catch (e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  void _updateBudgetOnAddOrEditTransaction(
      {required Transaction transaction, TransactionTile? editedTransaction}) {
    /*List<Account> updatedAccounts = [];
    final accounts = state.budget.accountList;
    //find the acc from editedTransaction and return amount
    //find the acc from transaction and update amount
    if (editedTransaction != null) {
      updatedAccounts = accounts.map((acc) {
        if (acc.id == editedTransaction.fromAccount!.id) {
          return acc.copyWith(
              balance: acc.balance +
                  (editedTransaction.type == TransactionType.EXPENSE
                      ? editedTransaction.amount
                      : -editedTransaction.amount));
        } else {
          return acc;
        }
      }).toList();
    } else {
      updatedAccounts = [...accounts];
    }
    updatedAccounts = updatedAccounts.map((acc) {
      if (acc.id == transaction.fromAccountId) {
        return acc.copyWith(
            balance: acc.balance +
                (transaction.type == TransactionType.EXPENSE
                    ? -transaction.amount
                    : transaction.amount));
      } else {
        return acc;
      }
    }).toList();

    _budgetRepository.pushUpdatedAccounts(updatedAccounts);*/
  }

  @override
  Future<void> close() {
    _categoriesSubscription.cancel();
    _accountsSubscription.cancel();
    return super.close();
  }
}
