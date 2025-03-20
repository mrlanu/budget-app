import 'package:qruto_budget/accounts_list/repository/account_repository.dart';
import 'package:qruto_budget/accounts_list/repository/account_repository_drift.dart';
import 'package:qruto_budget/categories/repository/category_repository.dart';
import 'package:qruto_budget/categories/repository/category_repository_drift.dart';
import 'package:qruto_budget/charts/repository/chart_repository.dart';
import 'package:qruto_budget/database/database.dart';
import 'package:qruto_budget/transaction/repository/transaction_repository.dart';
import 'package:qruto_budget/transaction/repository/transaction_repository_drift.dart';
import 'package:qruto_budget/utils/theme/cubit/theme_cubit.dart';
import 'package:qruto_budget/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../navigation/router.dart';

class App extends StatelessWidget {
  final AppDatabase _database;

  const App({super.key, required AppDatabase database}): _database = database;

  @override
  Widget build(BuildContext context) {
    final TransactionRepository transactionRepository =
        TransactionRepositoryDrift(database: _database);
    final AccountRepository accountRepository =
        AccountRepositoryDrift(database: _database);
    final CategoryRepository categoryRepository =
        CategoryRepositoryDrift(database: _database);
    final ChartRepository chartRepository = ChartRepositoryDrift(database: _database);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => _database),
        RepositoryProvider(create: (context) => categoryRepository),
        RepositoryProvider(create: (context) => accountRepository),
        RepositoryProvider(create: (context) => transactionRepository),
        RepositoryProvider(create: (context) => chartRepository,)
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

class AppView extends StatelessWidget {
  AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          _setSystemUIOverlayStyle(state.primaryColor);
          return ScreenUtilInit(
            designSize: const Size(500, 1085),
            minTextAdapt: true,
            splitScreenMode: true,
            child: MaterialApp.router(
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
            ),
          );
        },
      ),
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
