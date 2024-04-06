import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cache_client/cache_client.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthenticationRepository authenticationRepository,
    CacheClient? cacheClient,
  })  : _authenticationRepository = authenticationRepository,
        super(AuthState.unknown()) {
    on<_AuthUserChanged>(_onUserChanged);
    on<AuthLogoutRequested>(_onLogoutRequested);
    _userSubscription = _authenticationRepository.user.listen(
      (user) {
        add(_AuthUserChanged(user));
      },
    );
  }

  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;

  Future<void> _onUserChanged(
      _AuthUserChanged event, Emitter<AuthState> emit) async {
    if (event.user.isEmpty) {
      emit(const AuthState.unauthenticated());
    } else {
      await CacheClient.instance.setAccessToken(accessToken: event.user.token!);
      emit(AuthState.authenticated(event.user));
    }
  }

  void _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) {
    CacheClient.instance.deleteAccessToken();
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
