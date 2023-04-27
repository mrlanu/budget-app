import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(
          AppState.splash(),
        ) {
    on<_AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<SplashStart>(_onSplashStart);
    on<_SplashDone>(_onSplashDone);
    _userSubscription = _authenticationRepository.user.skip(1).listen(
          (user) {
        add(_AppUserChanged(user));
      },
    );
  }

  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;

  void _onSplashStart(SplashStart event, Emitter<AppState> emit){
    Timer(const Duration(milliseconds: 500), () => add(_SplashDone()));
  }

  void _onSplashDone(_SplashDone event, Emitter<AppState> emit){
    emit(_authenticationRepository.currentUser.isNotEmpty
        ? AppState.authenticated(_authenticationRepository.currentUser)
        : const AppState.unauthenticated());
  }

  void _onUserChanged(_AppUserChanged event, Emitter<AppState> emit) {
    emit(
      event.user.isNotEmpty
          ? AppState.authenticated(event.user)
          : const AppState.unauthenticated(),
    );
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
