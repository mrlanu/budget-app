import 'package:bloc/bloc.dart';
import 'package:budget_app/app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/repository/budget_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();
  final BudgetRepository _budgetRepository =
      BudgetRepositoryImpl(plugin: await SharedPreferences.getInstance());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(App(
    budgetRepository: _budgetRepository,
  ));
}
