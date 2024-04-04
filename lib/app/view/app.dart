import 'package:authentication_repository/authentication_repository.dart';
import 'package:budget_app/utils/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/auth.dart';
import '../../constants/constants.dart';
import '../../navigation/router.dart';
import '../../utils/theme/budget_theme.dart';

class App extends StatelessWidget {
  final AuthenticationRepository _authRepo = AuthenticationRepository();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => _authRepo,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc(authenticationRepository: _authRepo),
          ),
          BlocProvider(
            create: (context) => ThemeCubit(),
          ),
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          router.refresh();
          router.go('/');
        },
        child: BlocBuilder<ThemeCubit, AppColors>(
          builder: (context, state) {
            _setSystemUIOverlayStyle(state);
            return MaterialApp.router(
              routerConfig: router,
              debugShowCheckedModeBanner: false,
              themeMode: ThemeMode.system,
              theme: BudgetTheme(seedColors: state).lightTheme,
              darkTheme: BudgetTheme(seedColors: state).darkTheme,
            );
          },
        ));
  }
}

void _setSystemUIOverlayStyle(AppColors color) =>
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: color.primaryColor.shade700,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: null,
      statusBarColor: color.primaryColor.shade700,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));
