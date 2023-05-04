import 'package:authentication_repository/authentication_repository.dart';
import 'package:budget_app/accounts/view/accounts_page.dart';
import 'package:budget_app/app/app.dart';
import 'package:budget_app/login/login.dart';
import 'package:budget_app/overview/view/overview_page.dart';
import 'package:budget_app/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthenticationRepository _authenticationRepository;

  @override
  void initState() {
    super.initState();
    _authenticationRepository = AuthenticationRepository();
  }

  @override
  void dispose() {
   // _authenticationRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        create: (_) => AppBloc(
          authenticationRepository: _authenticationRepository,
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
    return ScreenUtilInit(
      designSize: const Size(1080, 2160),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: _navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              textTheme: GoogleFonts.montserratTextTheme(),
              useMaterial3: true,
              colorSchemeSeed: colorSelected.color,
              brightness: Brightness.light),
          darkTheme: ThemeData(
            colorSchemeSeed: colorSelected.color,
            useMaterial3: true,
            brightness: Brightness.dark,
          ),
          routes: {
            AccountsPage.routeName: (context) => AccountsPage(),
          },
          builder: (context, child) {
            return BlocListener<AppBloc, AppState>(
              listener: (context, state) {
                switch (state.status) {
                  case AppStatus.authenticated:
                    _navigator.pushAndRemoveUntil<void>(
                      OverviewPage.route(),
                          (route) => false,
                    );
                    break;
                  case AppStatus.unauthenticated:
                    _navigator.pushAndRemoveUntil<void>(
                      LoginPage.route(),
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
          /*home: BlocBuilder<AppBloc, AppState>(
            builder: (context, state) {
              switch (state.status) {
                case AppStatus.authenticated:
                  return OverviewPage();
                case AppStatus.unauthenticated:
                  return LoginPage();
                case AppStatus.splash:
                  return SplashPage();
              }
            },
          ),
          routes: {
            OverviewPage.routeName: (context) => OverviewPage(),
            AccountsPage.routeName: (context) => AccountsPage(),
          },*/
        );
      },
    );
  }
}
