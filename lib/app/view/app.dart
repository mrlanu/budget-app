import 'package:authentication_repository/authentication_repository.dart';
import 'package:budget_app/utils/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/auth.dart';
import '../../budgets/repository/budget_repository.dart';
import '../../constants/constants.dart';
import '../../navigation/router.dart';
import '../../transaction/repository/transactions_repository.dart';
import '../../utils/theme/budget_theme.dart';

class App extends StatelessWidget {
  final AuthenticationRepository _authRepo = AuthenticationRepository();
  final BudgetRepository _budgetRepository = BudgetRepositoryImpl();
  final TransactionsRepository _transactionsRepository =
      TransactionsRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => _authRepo,
        ),
        RepositoryProvider(create: (context) => _budgetRepository),
        RepositoryProvider(create: (context) => _transactionsRepository),
      ],
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
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            _setSystemUIOverlayStyle(state.primaryColor);
            return MaterialApp.router(
              routerConfig: router,
              debugShowCheckedModeBanner: false,
              themeMode: ThemeMode.values[state.mode],
              theme: BudgetTheme(seedColors: (
                primaryColor: state.primaryColor,
                secondaryColor: state.secondaryColor
              )).lightTheme,
              darkTheme: BudgetTheme(seedColors: (
                primaryColor: state.primaryColor,
                secondaryColor: state.secondaryColor
              )).darkTheme,
            );
          },
        ));
  }
}

void _setSystemUIOverlayStyle(MaterialColor color) =>
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: color.shade700,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: null,
      statusBarColor: color.shade700,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));
