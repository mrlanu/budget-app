import 'package:budget_app/accounts_list/repository/account_repository.dart';
import 'package:budget_app/accounts_list/repository/account_repository_drift.dart';
import 'package:budget_app/categories/repository/category_repository.dart';
import 'package:budget_app/categories/repository/category_repository_drift.dart';
import 'package:budget_app/charts/repository/chart_repository.dart';
import 'package:budget_app/database/database.dart';
import 'package:budget_app/transaction/repository/transaction_repository.dart';
import 'package:budget_app/transaction/repository/transaction_repository_drift.dart';
import 'package:budget_app/utils/theme/cubit/theme_cubit.dart';
import 'package:budget_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/constants.dart';
import '../../navigation/router.dart';

class App extends StatelessWidget {
  final AppDatabase database = AppDatabase();

  @override
  Widget build(BuildContext context) {
    final TransactionRepository transactionRepository =
        TransactionRepositoryDrift(database: database);
    final AccountRepository accountRepository =
        AccountRepositoryDrift(database: database);
    final CategoryRepository categoryRepository =
        CategoryRepositoryDrift(database: database);
    final ChartRepository chartRepository = ChartRepositoryDrift(database: database);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => database),
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
    return Responsive(
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
