import 'package:budget_app/app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'constants/colors.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  //Bloc.observer = const AppBlocObserver();
  /*SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: BudgetColors.systemBar,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarDividerColor: null,
    statusBarColor: BudgetColors.statusBar,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
  ));*/

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(App());
}
