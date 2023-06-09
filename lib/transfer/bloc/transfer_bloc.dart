import 'dart:async';
import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:budget_app/transfer/transfer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

import '../../accounts/models/account.dart';
import '../../accounts/repository/accounts_repository.dart';
import '../../categories/models/category.dart';
import '../../categories/repository/categories_repository.dart';
import '../repository/transfer_repository.dart';

part 'transfer_event.dart';
part 'transfer_state.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {

  final String budgetId;
  final TransferRepository _transferRepository;
  final CategoriesRepository _categoriesRepository;
  late final AccountsRepository _accountsRepository;

  TransferBloc({required this.budgetId, required TransferRepository transferRepository, required CategoriesRepository categoriesRepository, required AccountsRepository accountsRepository}) :
        _transferRepository = transferRepository, _categoriesRepository = categoriesRepository, _accountsRepository = accountsRepository,
        super(TransferState()) {
    on<TransferEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
