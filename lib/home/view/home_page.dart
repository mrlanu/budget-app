import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/home/cubit/home_cubit.dart';
import 'package:budget_app/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/constants.dart';
import '../../transactions/cubit/transactions_cubit.dart';
import '../../transactions/repository/transactions_repository.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => HomePage());
  }

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trRepo = context.read<TransactionsRepositoryImpl>();
    final budgetRepo = context.read<BudgetRepository>();
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (context) => HomeCubit(
              transactionsRepository: trRepo, budgetRepository: budgetRepo)),
      BlocProvider(
          create: (context) => TransactionsCubit(
              transactionsRepository: trRepo,
              budgetRepository: budgetRepo))
    ], child: isDisplayDesktop(context) ? HomeDesktopPage() : HomeMobilePage());
  }
}
