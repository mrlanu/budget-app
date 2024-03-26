import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/categories/view/categories_page.dart';
import 'package:budget_app/home/home.dart';
import 'package:budget_app/login/login.dart';
import 'package:budget_app/sign_up/sign_up.dart';
import 'package:budget_app/splash/splash.dart';
import 'package:budget_app/transaction/transaction.dart';
import 'package:budget_app/transfer/repository/transfer_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../app/bloc/app_bloc.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _buildingsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'buildingsNav');

final BudgetRepository _budgetRepository = BudgetRepositoryImpl();
final TransactionsRepository _transactionsRepository =
    TransactionsRepositoryImpl();
final TransferRepository _transferRepository = TransferRepositoryImpl();

/// The route configuration.
final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      redirect: (_, __) => '/login',
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/signup',
      builder: (BuildContext context, GoRouterState state) {
        return const SignUpPage();
      },
    ),
    GoRoute(
      path: '/splash',
      builder: (BuildContext context, GoRouterState state) {
        return SplashPage();
      },
    ),
    ShellRoute(
        builder: (context, state, child) => MultiRepositoryProvider(
              providers: [
                RepositoryProvider(create: (context) => _budgetRepository),
                RepositoryProvider(
                    create: (context) => _transactionsRepository),
                RepositoryProvider(
                  create: (context) => _transferRepository,
                )
              ],
              child: BlocProvider(
                create: (context) => HomeCubit(
                    transactionsRepository: _transactionsRepository,
                    budgetRepository: _budgetRepository)
                  ..initRequested(),
                child: child,
              ),
            ),
        routes: [
          StatefulShellRoute.indexedStack(
              builder: (BuildContext context, GoRouterState state,
                      StatefulNavigationShell navigationShell) =>
                  HomePage(navigationShell: navigationShell),
              branches: [
                StatefulShellBranch(
                    navigatorKey: _buildingsNavigatorKey,
                    routes: [
                      GoRoute(
                        path: '/expenses',
                        builder: (BuildContext context, GoRouterState state) {
                          return CategorySummaryList(
                            key: UniqueKey(),
                            homeTab: HomeTab.expenses,
                          );
                        },
                      ),
                    ]),
                StatefulShellBranch(routes: [
                  GoRoute(
                    path: '/incomes',
                    builder: (BuildContext context, GoRouterState state) {
                      return CategorySummaryList(
                        key: UniqueKey(),
                        homeTab: HomeTab.income,
                      );
                    },
                  ),
                ]),
                StatefulShellBranch(routes: [
                  GoRoute(
                    path: '/accounts',
                    builder: (BuildContext context, GoRouterState state) {
                      return CategorySummaryList(
                        key: UniqueKey(),
                        homeTab: HomeTab.accounts,
                      );
                    },
                  ),
                ]),
              ]),
          GoRoute(
            path: '/transaction',
            builder: (BuildContext context, GoRouterState state) {
              return TransactionPage(
                  key: UniqueKey(),
                  transactionType: TransactionType.values[
                      int.parse(state.uri.queryParameters['typeIndex']!)]);
            },
          ),
          GoRoute(
            path: '/transaction/:id',
            builder: (BuildContext context, GoRouterState state) {
              final homeCubit = context.read<HomeCubit>();
              final transaction = homeCubit.state.transactions.firstWhere(
                      (tr) => tr.getId == state.pathParameters['id']!)
                  as Transaction;
              return TransactionPage(
                  key: UniqueKey(),
                  transaction: transaction,
                  transactionType: TransactionType.values[
                      int.parse(state.uri.queryParameters['typeIndex']!)]);
            },
          ),
          GoRoute(
            path: '/categories',
            builder: (BuildContext context, GoRouterState state) {
              return CategoriesPage(
                  key: UniqueKey(),
                  transactionType: TransactionType.values[
                  int.parse(state.uri.queryParameters['typeIndex']!)]);
            },
          ),
        ]),
  ],
  redirect: _guard,
  debugLogDiagnostics: true,
);

Future<String?> _guard(BuildContext context, GoRouterState state) async {
  final authStatus = context.read<AppBloc>().state.status;
  final bool signedIn =
      authStatus == AppStatus.authenticated;
  if (authStatus == AppStatus.unknown) {
    return '/splash';
  }
  final bool signingIn =
      ['/login', '/login/signup', '/splash'].contains(state.matchedLocation);
  if (!signedIn && !signingIn) {
    return '/login';
  } else if (signedIn && signingIn) {
    return '/expenses';
  }
  return null;
}

GoRouter get router => _router;
