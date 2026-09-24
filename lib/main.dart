import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:qruto_budget/app/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qruto_budget/shared/notification_service.dart';

import 'database/database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  //Bloc.observer = const AppBlocObserver();

  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  await NotificationService.instance.init();
  final db = AppDatabase();

  runApp(App(database: db,));
}
