import 'package:authentication_repository/authentication_repository.dart';
import 'package:budget_app/app/app.dart';
import 'package:budget_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/constants.dart';
import '../../navigation/router.dart';
import '../../theme.dart';

class App extends StatelessWidget {
  final AuthenticationRepository _authRepo = AuthenticationRepository();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => _authRepo,
      child: BlocProvider(
        create: (_) => AppBloc(authenticationRepository: _authRepo),
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

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return BlocListener<AppBloc, AppState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          router.refresh();
          router.go('/');
        },
        child: MaterialApp.router(
          routerConfig: router,
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
                      borderSide: const BorderSide(
                          color: const Color(0xFF343434), width: 1)),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: const Color(0xFF343434), width: 1))),
              useMaterial3: true),
        ));
  }
}
