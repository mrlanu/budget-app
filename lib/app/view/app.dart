import 'package:budget_app/charts/repository/chart_repository.dart';
import 'package:budget_app/summary/repository/summary_repository.dart';
import 'package:budget_app/utils/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';

import '../../constants/constants.dart';
import '../../navigation/router.dart';
import '../../transaction/transaction.dart';
import '../../utils/theme/budget_theme.dart';

class App extends StatelessWidget {
  App({required this.isar});

  final Isar isar;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<BudgetRepository>(
            create: (context) => BudgetRepoIsarImpl(isar: isar)),
        RepositoryProvider<SummaryRepository>(
            create: (context) => SummaryRepository(isar: isar)),
        RepositoryProvider<ChartRepository>(
            create: (context) => ChartRepositoryImpl(isar: isar)),
      ],
      child: MultiBlocProvider(
        providers: [
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
    return BlocBuilder<ThemeCubit, ThemeState>(
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
    );
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
