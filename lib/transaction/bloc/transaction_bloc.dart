import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:budget_app/transaction/models/comprehensive_transaction.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

import '../../accounts_list/models/account.dart';
import '../../categories/models/category.dart';
import '../../subcategories/models/subcategory.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';
import '../repository/budget_repository.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final BudgetRepository _budgetRepository;
  late StreamSubscription<List<Account>> _accountsSubscription;
  late StreamSubscription<List<Category>> _categoriesSubscription;

  TransactionBloc({required BudgetRepository budgetRepository})
      : _budgetRepository = budgetRepository,
        super(TransactionState()) {
    on<TransactionEvent>(_onEvent, transformer: sequential());
    _accountsSubscription = _budgetRepository.accounts.listen((accounts) {
      add(TransactionAccountsChanged(accounts: accounts));
    });
    _categoriesSubscription =
        _budgetRepository.categories.listen((categories) {
      add(TransactionCategoriesChanged(categories: categories));
    });
  }

  Future<void> _onEvent(
      TransactionEvent event, Emitter<TransactionState> emit) async {
    return switch (event) {
      final TransactionFormLoaded e => _onFormLoaded(e, emit),
      final TransactionAmountChanged e => _onAmountChanged(e, emit),
      final TransactionDateChanged e => _onDateChanged(e, emit),
      final TransactionCategoryChanged e => _onCategoryChanged(e, emit),
      final TransactionCategoriesChanged e => _onCategoriesChanged(e, emit),
      final TransactionSubcategoryChanged e => _onSubcategoryChanged(e, emit),
      final TransactionSubcategoriesChanged e =>
        _onSubcategoriesChanged(e, emit),
      final TransactionAccountChanged e => _onAccountChanged(e, emit),
      final TransactionAccountsChanged e => _onAccountsChanged(e, emit),
      final TransactionNotesChanged e => _onNotesChanged(e, emit),
      final TransactionFormSubmitted e => _onFormSubmitted(e, emit),
    };
  }

  Future<void> _onFormLoaded(
    TransactionFormLoaded event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(trStatus: TransactionStatus.loading));
    Category? category;
    Subcategory? subcategory;
    Account? account;
    int? id;
    final tr = event.transaction;
    if (tr != null) {
      id = tr.id;
      category = tr.category!;
      subcategory = tr.subcategory!;
      account = tr.fromAccount;
    }
    //for amount update on desktop view
    await Future.delayed(Duration(milliseconds: 100));

    emit(state.copyWith(
        editedTransaction: tr,
        id: id,
        transactionType: event.transactionType,
        amount: tr == null ? Amount.pure() : Amount.dirty(tr.amount.toString()),
        date: tr?.dateTime ?? DateTime.now(),
        category: () => category,
        subcategory: () => subcategory,
        account: account,
        description: tr?.description ?? '',
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
        category: () => event.category, subcategory: () => null));
  }

  void _onCategoriesChanged(TransactionCategoriesChanged event,
      Emitter<TransactionState> emit) async {
    emit(state.copyWith(categories: event.categories));
  }

  void _onSubcategoryChanged(
      TransactionSubcategoryChanged event, Emitter<TransactionState> emit) {
    emit(state.copyWith(subcategory: () => event.subcategory));
  }

  void _onSubcategoriesChanged(
      TransactionSubcategoriesChanged event, Emitter<TransactionState> emit) {
    emit(state.copyWith(subcategories: event.subcategories));
  }

  void _onAccountChanged(
      TransactionAccountChanged event, Emitter<TransactionState> emit) {
    emit(state.copyWith(account: event.account));
  }

  void _onAccountsChanged(
      TransactionAccountsChanged event, Emitter<TransactionState> emit) {
    emit(state.copyWith(accounts: event.accounts));
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
        subcategory: state.subcategory!,
        amount: double.parse(state.amount.value))
      ..category.value = state.category
      ..fromAccount.value = state.account;
    try {
      await _updateAccountsOnAddOrEditTransaction(
          transaction: transaction,
          oldTransaction: state.editedTransaction);
      await _budgetRepository.saveTransaction(transaction);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
      Navigator.of(event.context!).pop();
    } catch (e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  @override
  Future<void> close() {
    _accountsSubscription.cancel();
    _categoriesSubscription.cancel();
    return super.close();
  }

  Future<void> _updateAccountsOnAddOrEditTransaction(
      {required Transaction transaction, ComprehensiveTransaction? oldTransaction}) async {
    List<Account> updatedAccounts = [];
    //find the acc from editedTransaction and return amount
    //find the acc from transaction and update amount
    if (oldTransaction != null) {
      updatedAccounts = state.accounts.map((acc) {
        if (acc.id == oldTransaction.fromAccount!.id) {
          return acc.copyWith(
              category: acc.category,
              balance: acc.balance +
                  (oldTransaction.type == TransactionType.EXPENSE
                      ? oldTransaction.amount
                      : -oldTransaction.amount));
        } else {
          return acc;
        }
      }).toList();
    } else {
      updatedAccounts = [...state.accounts];
    }
    updatedAccounts = updatedAccounts.map((acc) {
      if (acc.id == transaction.fromAccount.value!.id) {
        return acc.copyWith(
            category: acc.category,
            balance: acc.balance +
                (transaction.type == TransactionType.EXPENSE
                    ? -transaction.amount
                    : transaction.amount));
      } else {
        return acc;
      }
    }).toList();

    await _budgetRepository.saveAccounts(updatedAccounts);
  }
}
