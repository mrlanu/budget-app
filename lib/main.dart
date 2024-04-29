import 'package:budget_app/app/app.dart';
import 'package:budget_app/categories/models/category.dart';
import 'package:budget_app/subcategories/models/models.dart';
import 'package:budget_app/transaction/models/transaction.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'accounts_list/models/account.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  //Bloc.observer = const AppBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [TransactionSchema, CategorySchema, AccountSchema, SubcategorySchema],
    directory: dir.path,
  );

  runApp(App(isar: isar,));
}
