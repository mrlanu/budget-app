import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:equatable/equatable.dart';

import '../../shared/models/budget.dart';

part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(
      {required AuthenticationRepository authenticationRepository,
      required BudgetRepository budgetRepository})
      : _authenticationRepository = authenticationRepository,
        _budgetRepository = budgetRepository,
        super(
          AppState.unknown(),
        ) {
    on<_AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    _userSubscription = _authenticationRepository.user.listen(
      (user) {
        add(_AppUserChanged(user));
      },
    );
  }

  final AuthenticationRepository _authenticationRepository;
  final BudgetRepository _budgetRepository;
  late final StreamSubscription<User> _userSubscription;

  Future<void> _onUserChanged(
      _AppUserChanged event, Emitter<AppState> emit) async {
    if (event.user.isEmpty) {
      emit(const AppState.unauthenticated());
    } else {
      await _budgetRepository.fetchBudget();
      emit(AppState.authenticated(event.user));
    }
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
