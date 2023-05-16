part of 'app_bloc.dart';

abstract class AppEvent {
  const AppEvent();
}

class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}


class SplashStart extends AppEvent {
  const SplashStart();
}

class _SplashDone extends AppEvent {
  const _SplashDone();
}

class _AppUserChanged extends AppEvent {
  const _AppUserChanged(this.user);

  final User user;
}

class _FetchBudget extends AppEvent {}
