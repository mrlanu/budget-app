import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cache/cache.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(AuthState.unknown()) {
    on<_AuthUserChanged>(_onUserChanged);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthEmailVerificationRequested>(_onAuthEmailVerificationRequested);
    _userSubscription = _authenticationRepository.user.listen(
      (user) {
        add(_AuthUserChanged(user));
      },
    );
  }

  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;
  late final Timer? timer;

  Future<void> _onAuthEmailVerificationRequested(
      AuthEmailVerificationRequested event, Emitter<AuthState> emit) async {
    final user = await _reloadUser();
    if(user.isVerified!){
      add(_AuthUserChanged(user));
    }
    /*timer = Timer.periodic(
      Duration(seconds: 5),
          (_) async {
        final user = await _reloadUser();
        if(user.isVerified!){
          timer!.cancel();
          add(_AuthUserChanged(user));
        }
      },
    );*/
  }

  Future<void> _onUserChanged(
      _AuthUserChanged event, Emitter<AuthState> emit) async {
    if (event.user.isEmpty) {
      emit(const AuthState.unauthenticated());
    } else {
      if (event.user.isVerified!) {
        await Cache.instance.setAccessToken(accessToken: event.user.token!);
        emit(AuthState.authenticated(event.user));
      } else {
        await _authenticationRepository.sendVerificationEmail();
        emit(AuthState.unverified());
      }
    }
  }

  Future<User> _reloadUser() => _authenticationRepository.reloadUser();

  void _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) {
    Cache.instance.deleteAccessToken();
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    timer?.cancel();
    return super.close();
  }
}
