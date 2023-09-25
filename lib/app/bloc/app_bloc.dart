import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/budgets/models/budget.dart';
import 'package:budget_app/constants/api.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    if (event.user.isNotEmpty) {
      _setValue('userId', event.user.id!);
      await _fetchAvailableBudgets(event.user.id!);
      await _budgetRepository.init();
      emit(AppState.authenticated(event.user));
    } else {
      emit(const AppState.unauthenticated());
    }
  }

  Future<void> _fetchAvailableBudgets(String userId) async {
    var budgets = await _budgetRepository.fetchAvailableBudgets(userId);
    if(budgets.isEmpty){
      await _budgetRepository.createBeginningBudget(userId: userId);
      budgets = await _budgetRepository.fetchAvailableBudgets(userId);
    }
    await _storeLastSelectedBudgetId(budgets);
  }

  Future<void> _storeLastSelectedBudgetId(List<Budget> budgets) async {
    final budgetIdInMemory = await getCurrentBudgetId();
    //there could be stored budgetId from previous user on this device
    final isBudgetInMemoryNotBelongUser = budgets.where((element) => element.id == budgetIdInMemory).isEmpty;
    if(isBudgetInMemoryNotBelongUser){
      await _setValue('currentBudgetId', budgets[0].id);
    }
    print('CURRENT BUDGET ID: ${await getCurrentBudgetId()}');
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  Future<void> _setValue(String key, String value) async {
    final _plugin = await SharedPreferences.getInstance();
    _plugin.setString(key, value);
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
