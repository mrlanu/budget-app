import 'package:budget_app/accounts_list/view/accounts_list_page.dart';
import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/categories/view/categories_page.dart';
import 'package:budget_app/home/home.dart';
import 'package:budget_app/login/login.dart';
import 'package:budget_app/sign_up/sign_up.dart';
import 'package:budget_app/splash/splash.dart';
import 'package:budget_app/transaction/transaction.dart';
import 'package:budget_app/transfer/repository/transfer_repository.dart';
import 'package:budget_app/transfer/transfer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../accounts_list/account_edit/view/account_edit_dialog.dart';
import '../app/bloc/app_bloc.dart';

GoRouter get router => _router;

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
    ..._authRoutes,
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
          ..._homeTabsRoutes,
          ..._individualRoutes,
        ]),
  ],
  redirect: _guard,
  debugLogDiagnostics: true,
);

Future<String?> _guard(BuildContext context, GoRouterState state) async {
  final authStatus = context.read<AppBloc>().state.status;
  final bool signedIn = authStatus == AppStatus.authenticated;
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

final List<RouteBase> _authRoutes = [
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
];

final List<RouteBase> _homeTabsRoutes = [
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
              );
            },
          ),
        ]),
      ]),
];

final List<RouteBase> _individualRoutes = [
  GoRoute(
    path: '/transaction',
    builder: (BuildContext context, GoRouterState state) {
      return TransactionPage(
          key: UniqueKey(),
          transactionType: TransactionType
              .values[int.parse(state.uri.queryParameters['typeIndex']!)]);
    },
  ),
  GoRoute(
    path: '/transaction/:id',
    builder: (BuildContext context, GoRouterState state) {
      final homeCubit = context.read<HomeCubit>();
      final transaction = homeCubit.state.transactionList
          .firstWhere((tr) => tr.id == state.pathParameters['id']!);
      return TransactionPage(
          key: UniqueKey(),
          transaction: transaction,
          transactionType: TransactionType
              .values[int.parse(state.uri.queryParameters['typeIndex']!)]);
    },
  ),
  GoRoute(
    path: '/transfer',
    builder: (BuildContext context, GoRouterState state) {
      return TransferPage(key: UniqueKey());
    },
  ),
  GoRoute(
    path: '/transfer/:id',
    builder: (BuildContext context, GoRouterState state) {
      final homeCubit = context.read<HomeCubit>();
      final transfer = homeCubit.state.transactionList
          .firstWhere((tr) => tr.id == state.pathParameters['id']!);
      return TransferPage(key: UniqueKey(), transaction: transfer);
    },
  ),
  GoRoute(
    path: '/categories',
    builder: (BuildContext context, GoRouterState state) {
      return CategoriesPage(
          key: UniqueKey(),
          transactionType: TransactionType
              .values[int.parse(state.uri.queryParameters['typeIndex']!)]);
    },
  ),
  GoRoute(
    path: '/accounts-list',
    builder: (BuildContext context, GoRouterState state) {
      return AccountsListPage(key: UniqueKey());
    },
  ),
  GoRoute(
    path: '/acc-modal',
    pageBuilder: (BuildContext context, GoRouterState state) {
      return DialogPage(builder: (_) => const AccountEditDialog());
    },
  ),
  GoRoute(
    path: '/acc-modal/:id',
    pageBuilder: (BuildContext context, GoRouterState state) {
      final homeCubit = context.read<HomeCubit>();
      final acc = homeCubit.state.budget.accountList
          .firstWhere((acc) => acc.id == state.pathParameters['id']!);
      return DialogPage(
          builder: (_) => AccountEditDialog(
                account: acc,
              ));
    },
  ),
];

///Wrapper for open Dialog with go_router
class DialogPage<T> extends Page<T> {
  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;
  final bool useSafeArea;
  final CapturedThemes? themes;
  final WidgetBuilder builder;

  const DialogPage({
    required this.builder,
    this.anchorPoint,
    this.barrierColor = Colors.black54,
    this.barrierDismissible = true,
    this.barrierLabel,
    this.useSafeArea = true,
    this.themes,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route<T> createRoute(BuildContext context) => DialogRoute<T>(
      context: context,
      settings: this,
      builder: builder,
      anchorPoint: anchorPoint,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      themes: themes);
}
