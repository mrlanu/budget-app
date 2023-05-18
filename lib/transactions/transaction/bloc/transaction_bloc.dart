import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

import '../../../accounts/models/account_brief.dart';
import '../../../shared/models/category.dart';
import '../../../shared/models/subcategory.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionState.initial()) {
    //on<TransactionFormLoaded>(_onTransactionFormLoaded);
  }

 /* Future<void> _onTransactionFormLoaded(
      TransactionFormLoaded event,
      Emitter<TransactionState> emit,
      ) async {
    emit(state.copyWith(status: ));
    final brands = await _newCarRepository.fetchBrands();
    emit(NewCarState.brandsLoadSuccess(brands: brands));
  }*/
}
