import 'package:authentication_repository/authentication_repository.dart';
import 'package:budget_app/accounts/repository/accounts_repository.dart';
import 'package:budget_app/app/app.dart';
import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/categories/repository/categories_repository.dart';
import 'package:budget_app/colors.dart';
import 'package:budget_app/constants/api.dart';
import 'package:budget_app/home/view/home_page.dart';
import 'package:budget_app/login/login.dart';
import 'package:budget_app/sign_up/sign_up.dart';
import 'package:budget_app/splash/splash.dart';
import 'package:budget_app/transactions/repository/transactions_repository.dart';
import 'package:budget_app/transfer/repository/transfer_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/constants.dart';
import '../../subcategories/repository/subcategories_repository.dart';
import '../../theme.dart';
import '../../transactions/transaction/view/transaction_page.dart';

class App extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository(firebaseAuth: FirebaseAuth.instance);

  final BudgetRepository _budgetRepository;

  App({required BudgetRepository budgetRepository})
      : _budgetRepository = budgetRepository;

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
  ColorSeed colorSelected = ColorSeed.baseColor;
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return ScreenUtilInit(
      designSize: const Size(1080, 2160),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider(create: (context) => CategoriesRepositoryImpl()),
            RepositoryProvider(
              create: (context) => AccountsRepositoryImpl(),
            ),
            RepositoryProvider(
                create: (context) => TransactionsRepositoryImpl()),
            RepositoryProvider(
                create: (context) => SubcategoriesRepositoryImpl()),
            RepositoryProvider(
              create: (context) => TransferRepositoryImpl(),
            )
          ],
          child: MaterialApp(
            navigatorKey: _navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                textTheme: GoogleFonts.robotoCondensedTextTheme(),
                cardTheme: Theme.of(context).cardTheme.copyWith(elevation: 4),
                appBarTheme: AppBarTheme(
                    backgroundColor: BudgetColors.teal900,
                    foregroundColor: BudgetColors.teal50),
                colorScheme: ThemeData.light().colorScheme.copyWith(
                      primary: BudgetColors.teal900,
                      tertiary: BudgetColors.amber800,
                      tertiaryContainer: BudgetColors.amber800,
                      onPrimaryContainer: Colors.white70,
                      surface: BudgetColors.teal100,
                      background: BudgetColors.teal50,
                    ),
                inputDecorationTheme: const InputDecorationTheme(
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: const Color(0xFF343434), width: 1)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: const Color(0xFF343434), width: 1))
                    ),
                useMaterial3: true),
            /*darkTheme: ThemeData(
              cardTheme: Theme.of(context).cardTheme.copyWith(elevation: 4),
              useMaterial3: true,
              brightness: Brightness.dark,
            ),*/
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
