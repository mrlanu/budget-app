import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:budget_app/budgets/budgets.dart';
import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/transaction/models/comprehensive_transaction.dart';
import 'package:cache_client/cache_client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

import '../../accounts_list/models/account.dart';
import '../../budgets/repository/budget_repository.dart';
import '../../categories/models/category.dart';
import '../../subcategories/models/subcategory.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';
import '../repository/transactions_repository.dart';

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
    _budgetSubscription = _budgetRepository.budget.listen((budget) {
      add(TransactionBudgetChanged(budget: budget));
    });
    on<TransactionEvent>(_onEvent, transformer: sequential());
  }

  Future<void> _onEvent(
      TransactionEvent event, Emitter<TransactionState> emit) async {
    return switch (event) {
      final TransactionBudgetChanged e => _onBudgetChanged(e, emit),
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

  Future<void> _onBudgetChanged(
    TransactionBudgetChanged event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(budget: event.budget));
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
      budgetId: (await CacheClient.instance.getBudgetId())!,
      date: state.date ?? DateTime.now(),
      type: state.transactionType,
      amount: double.parse(state.amount.value),
      categoryId: state.category?.id,
      subcategoryId: state.subcategory?.id,
      fromAccountId: state.account!.id,
    );
    try {
      await state.editedTransaction == null
          ? _transactionsRepository.createTransaction(transaction)
          : _transactionsRepository.updateTransaction(transaction);
      _updateBudgetOnAddOrEditTransaction(
          transaction: transaction, editedTransaction: state.editedTransaction);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
      isDisplayDesktop(event.context!)
          ? add(TransactionFormLoaded(transactionType: transaction.type!))
          : Navigator.of(event.context!).pop();
    } catch (e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  void _updateBudgetOnAddOrEditTransaction(
      {required Transaction transaction, ComprehensiveTransaction? editedTransaction}) {
    List<Account> updatedAccounts = [];
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

    _budgetRepository.pushUpdatedAccounts(updatedAccounts);
  }

  @override
  Future<void> close() {
    _budgetSubscription.cancel();
    return super.close();
  }
}
