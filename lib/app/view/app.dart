import 'package:authentication_repository/authentication_repository.dart';
import 'package:budget_app/app/app.dart';
import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/colors.dart';
import 'package:budget_app/transactions/repository/transactions_repository.dart';
import 'package:budget_app/transfer/repository/transfer_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/constants.dart';
import '../../routes/routes.dart';
import '../../theme.dart';

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
        RepositoryProvider(create: (context) => _budgetRepository),
      ],
      child: BlocProvider(
        create: (_) =>
            AppBloc(authenticationRepository: _authenticationRepository),
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

  final TransactionsRepository _transactionRepository =
      TransactionsRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => _transactionRepository),
        RepositoryProvider(
          create: (context) => TransferRepositoryImpl(),
        )
      ],
      child: MaterialApp(
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
        /*darkTheme: ThemeData(
              cardTheme: Theme.of(context).cardTheme.copyWith(elevation: 4),
              useMaterial3: true,
              brightness: Brightness.dark,
            ),*/
        home: FlowBuilder<AppStatus>(
          state: context.select((AppBloc bloc) => bloc.state.status),
          onGeneratePages: onGenerateAppViewPages,
        ),
      ),
    );
  }
}
