import 'package:authentication_repository/authentication_repository.dart';
import 'package:budget_app/accounts/repository/accounts_repository.dart';
import 'package:budget_app/app/app.dart';
import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/categories/repository/categories_repository.dart';
import 'package:budget_app/home/view/home_page.dart';
import 'package:budget_app/login/login.dart';
import 'package:budget_app/shared/repositories/shared_repository.dart';
import 'package:budget_app/sign_up/sign_up.dart';
import 'package:budget_app/splash/splash.dart';
import 'package:budget_app/transactions/repository/transactions_repository.dart';
import 'package:budget_app/transfer/repository/transfer_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../subcategories/repository/subcategories_repository.dart';
import '../../theme.dart';
import '../../transactions/transaction/view/transaction_page.dart';

class App extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();
  final BudgetRepository _budgetRepository = BudgetRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => _authenticationRepository,
        ),
        RepositoryProvider(
          create: (context) => _budgetRepository,
        )
      ],
      child: BlocProvider(
        create: (_) => AppBloc(
          authenticationRepository: _authenticationRepository,
          budgetRepository: _budgetRepository,
        ),
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
  ThemeMode themeMode = ThemeMode.system;
  ColorSeed colorSelected = ColorSeed.orange;
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    final budget = context.select((AppBloc bloc) => bloc.state.budget);
    return ScreenUtilInit(
      designSize: const Size(1080, 2160),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider(
                create: (context) => SharedRepositoryImpl(user: user)),
            RepositoryProvider(
                create: (context) => CategoriesRepositoryImpl(user: user, budget: budget!)),
            RepositoryProvider(
              create: (context) => AccountsRepositoryImpl(user: user,  budget: budget!),
            ),
            RepositoryProvider(
                create: (context) => TransactionsRepositoryImpl(user: user, budget: budget!)),
            RepositoryProvider(
                create: (context) => SubcategoriesRepositoryImpl(user: user)),
            RepositoryProvider(create: (context) => TransferRepositoryImpl(),)
          ],
          child: MaterialApp(
            navigatorKey: _navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                textTheme: GoogleFonts.montserratTextTheme(),
                cardTheme: Theme.of(context).cardTheme.copyWith(elevation: 2),
                useMaterial3: true,
                colorSchemeSeed: colorSelected.color,
                brightness: Brightness.light),
            darkTheme: ThemeData(
              cardTheme: Theme.of(context).cardTheme.copyWith(elevation: 2),
              colorSchemeSeed: colorSelected.color,
              useMaterial3: true,
              brightness: Brightness.dark,
            ),
            routes: {
              HomePage.routeName: (context) => HomePage(),
              //AccountsPage.routeName: (context) => AccountsPage(),
              SignUpPage.routeName: (context) => SignUpPage(),
              LoginPage.routeName: (context) => LoginPage(),
              TransactionPage.routeName: (context) => TransactionPage(),
              //TransactionsPage.routeName: (context) => TransactionsPage(),
            },
            builder: (context, child) {
              return BlocListener<AppBloc, AppState>(
                listener: (context, state) {
                  switch (state.status) {
                    case AppStatus.authenticated:
                      _navigator.pushNamedAndRemoveUntil<void>(
                        HomePage.routeName,
                        (route) => false,
                      );
                      break;
                    case AppStatus.unauthenticated:
                      _navigator.pushNamedAndRemoveUntil<void>(
                        LoginPage.routeName,
                        (route) => false,
                      );
                      break;
                    case AppStatus.unknown:
                      break;
                  }
                },
                child: child,
              );
            },
            onGenerateRoute: (_) => SplashPage.route(),
          ),
        );
      },
    );
  }
}
