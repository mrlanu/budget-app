import 'package:authentication_repository/authentication_repository.dart';
import 'package:budget_app/accounts/repository/accounts_repository.dart';
import 'package:budget_app/app/app.dart';
import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/categories/repository/categories_repository.dart';
import 'package:budget_app/transactions/repository/transactions_repository.dart';
import 'package:budget_app/transfer/repository/transfer_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/constants.dart';
import '../../routes/routes.dart';
import '../../subcategories/repository/subcategories_repository.dart';
import '../../utils/utils.dart';

class App extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository(firebaseAuth: FirebaseAuth.instance);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => _authenticationRepository,
        ),
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
  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => BudgetRepositoryImpl()),
        RepositoryProvider(create: (context) => CategoriesRepositoryImpl()),
        RepositoryProvider(
          create: (context) => AccountsRepositoryImpl(),
        ),
        RepositoryProvider(create: (context) => TransactionsRepositoryImpl()),
        RepositoryProvider(create: (context) => SubcategoriesRepositoryImpl()),
        RepositoryProvider(
          create: (context) => TransferRepositoryImpl(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: BudgetTheme.lightTheme,
        darkTheme: BudgetTheme.darkTheme,
        home: FlowBuilder<AppStatus>(
          state: context.select((AppBloc bloc) => bloc.state.status),
          onGeneratePages: onGenerateAppViewPages,
        ),
      ),
    );
  }
}
