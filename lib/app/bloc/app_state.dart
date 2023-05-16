part of 'app_bloc.dart';

enum AppStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user = User.empty,
    this.budget,
  });

  const AppState.unknown(): this._(status: AppStatus.unknown);

  const AppState.authenticated(User user, Budget budget)
      : this._(status: AppStatus.authenticated, user: user, budget: budget);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  final AppStatus status;
  final User user;
  final Budget? budget;

  @override
  List<Object> get props => [status, user];
}
