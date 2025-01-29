part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthEmailVerificationRequested extends AuthEvent {
  const AuthEmailVerificationRequested();
}

class _AuthUserChanged extends AuthEvent {
  const _AuthUserChanged(this.user);

  final User user;
}
