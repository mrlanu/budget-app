import 'package:budget_app/accounts_list/view/accounts_list_page.dart';
import 'package:budget_app/categories/category_edit/view/category_edit_dialog.dart';
import 'package:budget_app/categories/view/categories_page.dart';
import 'package:budget_app/home/home.dart';
import 'package:budget_app/subcategories/subcategory_edit/subcategory_edit.dart';
import 'package:budget_app/subcategories/view/subcategories_page.dart';
import 'package:budget_app/transaction/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../accounts_list/account_edit/view/account_edit_dialog.dart';
import '../budgets/repository/budget_repository.dart';
import '../settings/settings.dart';

GoRouter get router => _router;

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _buildingsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'buildingsNav');

/// The route configuration.
final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/expenses',
  routes: [
    ShellRoute(
        builder: (context, state, child) => BlocProvider(
              create: (context) => HomeCubit(
                  transactionsRepository:
                      context.read<TransactionsRepository>(),
                  budgetRepository: context.read<BudgetRepository>())
                ..initRequested(),
              child: child,
            ),
        routes: [
          ..._homeTabsRoutes,
          ..._individualRoutes,
        ]),
  ],
  //redirect: _guard,
  debugLogDiagnostics: true,
);

final List<RouteBase> _homeTabsRoutes = [
  StatefulShellRoute.indexedStack(
      builder: (BuildContext context, GoRouterState state,
              StatefulNavigationShell navigationShell) =>
          HomePage(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(navigatorKey: _buildingsNavigatorKey, routes: [
          GoRoute(
            path: '/expenses',
            builder: (BuildContext context, GoRouterState state) {
              return CategorySummaryList();
            },
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/incomes',
            builder: (BuildContext context, GoRouterState state) {
              return CategorySummaryList();
            },
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/accounts',
            builder: (BuildContext context, GoRouterState state) {
              return CategorySummaryList();
            },
          ),
        ]),
      ]),
];

final List<RouteBase> _individualRoutes = [
  GoRoute(
      path: '/categories',
      builder: (BuildContext context, GoRouterState state) {
        return CategoriesPage(
            transactionType: TransactionType
                .values[int.parse(state.uri.queryParameters['typeIndex']!)]);
      },
      routes: [
        GoRoute(
          path: 'new',
          pageBuilder: (BuildContext context, GoRouterState state) {
            final type = TransactionType
                .values[int.parse(state.uri.queryParameters['typeIndex']!)];
            return DialogPage(
                builder: (_) => CategoryEditDialog(
                      type: type,
                    ));
          },
        ),
        GoRoute(
          path: 'edit/:id',
          pageBuilder: (BuildContext context, GoRouterState state) {
            final homeCubit = context.read<HomeCubit>();
            final cat = homeCubit.state.budget.categoryList
                .firstWhere((cat) => cat.id == state.pathParameters['id']!);
            final type = TransactionType
                .values[int.parse(state.uri.queryParameters['typeIndex']!)];
            return DialogPage(
                builder: (_) => CategoryEditDialog(
                      category: cat,
                      type: type,
                    ));
          },
        ),
      ]),
  GoRoute(
      path: '/subcategories',
      builder: (BuildContext context, GoRouterState state) {
        final catId = state.uri.queryParameters['categoryId']!;
        final category =
            context.read<HomeCubit>().state.budget.getCategoryById(catId);
        return SubcategoriesPage(
          category: category,
        );
      },
      routes: [
        GoRoute(
          path: 'new',
          pageBuilder: (BuildContext context, GoRouterState state) {
            final catId = state.uri.queryParameters['categoryId']!;
            final category =
                context.read<HomeCubit>().state.budget.getCategoryById(catId);
            return DialogPage(
                builder: (_) => SubcategoryEditDialog(
                      category: category,
                    ));
          },
        ),
        GoRoute(
          path: 'edit/:id',
          pageBuilder: (BuildContext context, GoRouterState state) {
            final catId = state.uri.queryParameters['categoryId']!;
            final category =
                context.read<HomeCubit>().state.budget.getCategoryById(catId);
            final subcategory = category.subcategoryList
                .firstWhere((cat) => cat.id == state.pathParameters['id']!);
            return DialogPage(
                builder: (_) => SubcategoryEditDialog(
                      category: category,
                      subcategory: subcategory,
                    ));
          },
        ),
      ]),
  GoRoute(
      path: '/accounts-list',
      builder: (BuildContext context, GoRouterState state) {
        return AccountsListPage();
      },
      routes: [
        GoRoute(
          path: 'new',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return DialogPage(builder: (_) => const AccountEditDialog());
          },
        ),
        GoRoute(
          path: 'edit/:id',
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
      ]),
  GoRoute(
    path: '/settings',
    builder: (BuildContext context, GoRouterState state) {
      return SettingsPage();
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
