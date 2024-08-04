import 'package:authentication_repository/authentication_repository.dart';
import 'package:budget_app/utils/theme/cubit/theme_cubit.dart';
import 'package:budget_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';

import '../../auth/auth.dart';
import '../../budgets/repository/budget_repository.dart';
import '../../constants/constants.dart';
import '../../navigation/router.dart';
import '../../transaction/repository/transactions_repository.dart';

class App extends StatelessWidget {
  App({this.isar});

  final Isar? isar;
  final AuthenticationRepository _authRepo = AuthenticationRepository();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => _authRepo),
        RepositoryProvider(
            create: (context) => isar == null
                ? BudgetRepositoryImpl()
                : BudgetRepositoryIsar(isar: isar!)),
        RepositoryProvider(
            create: (context) => isar == null
                ? TransactionsRepositoryImpl()
                : TransactionsRepositoryIsar(isar: isar!)),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc(authenticationRepository: _authRepo),
          ),
          BlocProvider(create: (context) => ThemeCubit()),
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
        child: Responsive(
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
          ),
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
