part of 'auth_bloc.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
  unknown
}

class AuthState extends Equatable {
  const AuthState._({
    required this.status,
    this.user = User.empty,
  });

  const AuthState.authenticated(User user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated() : this._(status: AuthStatus.unauthenticated);

  const AuthState.unknown() : this._(status: AuthStatus.unknown);

  final AuthStatus status;
  final User user;

  @override
  List<Object> get props => [status, user];
}
