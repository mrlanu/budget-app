import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:budget_app/accounts_list/account_edit/model/account_with_details.dart';
import 'package:budget_app/accounts_list/repository/account_repository.dart';
import 'package:budget_app/categories/repository/category_repository.dart';
import 'package:budget_app/database/database.dart';
import 'package:budget_app/database/transaction_with_detail.dart';
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

  Future<void> _onFormLoaded(
    TransactionFormLoaded event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(trStatus: TransactionStatus.loading));
    if (event.transactionId != null) {
      final editedTransaction = await _transactionsRepository
          .getTransactionById(event.transactionId!);
      final account = await _accountsRepository
          .getAccountById(editedTransaction.fromAccount.id);
      emit(state.copyWith(
          editedTransaction: editedTransaction,
          id: editedTransaction.id,
          transactionType: editedTransaction.type,
          amount: Amount.dirty(editedTransaction.amount.toString()),
          date: editedTransaction.date,
          category: () => editedTransaction.category,
          subcategory: () => editedTransaction.subcategory,
          account: account,
          description: editedTransaction.description,
          trStatus: TransactionStatus.success,
          isValid: true));
    } else {
      emit(state.copyWith(
        trStatus: TransactionStatus.success,
      ));
    }
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
      int transactionId;
      if (isIdExist) {
        await _transactionsRepository.updateTransaction(
            id: state.id!,
            date: state.date!,
            type: state.transactionType,
            amount: double.parse(state.amount.value),
            categoryId: state.category!.id,
            subcategoryId: state.subcategory!.id,
            fromAccountId: state.account!.id!,
            description: state.description!);
        transactionId = state.id!;
      } else {
        transactionId = await _transactionsRepository.insertTransaction(
            date: state.date!,
            type: state.transactionType,
            amount: double.parse(state.amount.value),
            categoryId: state.category!.id,
            subcategoryId: state.subcategory!.id,
            fromAccountId: state.account!.id!,
            description: state.description!);
      }
      final newTransaction =
          await _transactionsRepository.getTransactionById(transactionId);
      _updateAccountOnAddOrEditTransaction(
          editedTransaction: state.editedTransaction,
          newTransaction: newTransaction);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
      Navigator.of(event.context!).pop();
    } catch (e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  void _updateAccountOnAddOrEditTransaction(
      {TransactionWithDetails? editedTransaction,
      required TransactionWithDetails newTransaction}) async {
    List<Account> updatedAccounts = [];
    final accounts = await _accountsRepository.getAllAccounts();
    //find the acc from editedTransaction and return amount
    //find the acc from transaction and update amount
    if (editedTransaction != null) {
      updatedAccounts = accounts.map((acc) {
        if (acc.id == editedTransaction.fromAccount.id) {
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
      if (acc.id == newTransaction.fromAccount.id) {
        return acc.copyWith(
            balance: acc.balance +
                (newTransaction.type == TransactionType.EXPENSE
                    ? -newTransaction.amount
                    : newTransaction.amount));
      } else {
        return acc;
      }
    }).toList();

    updatedAccounts.forEach(
      (acc) => _accountsRepository.updateAccount(
          id: acc.id,
          name: acc.name,
          includeInTotal: acc.includeInTotal,
          balance: acc.balance,
          initialBalance: acc.initialBalance,
          currency: acc.currency ?? '',
          categoryId: acc.categoryId),
    );
  }

  @override
  Future<void> close() {
    _categoriesSubscription.cancel();
    _accountsSubscription.cancel();
    return super.close();
  }
}
