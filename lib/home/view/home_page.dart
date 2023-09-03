import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../accounts/repository/accounts_repository.dart';
import '../../categories/repository/categories_repository.dart';
import '../../constants/constants.dart';
import '../../subcategories/repository/subcategories_repository.dart';
import '../../transactions/cubit/transactions_cubit.dart';
import '../../transactions/models/transactions_view_filter.dart';
import '../../transactions/repository/transactions_repository.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  static Route<void> route(){
    return MaterialPageRoute(builder: (context) => HomePage());
  }

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => HomeCubit(
              budgetRepository: context.read<BudgetRepositoryImpl>(),
              accountsRepository: context.read<AccountsRepositoryImpl>(),
              categoriesRepository:
              context.read<CategoriesRepositoryImpl>(),
              transactionsRepository:
              context.read<TransactionsRepositoryImpl>(),
              subcategoriesRepository:
              context.read<SubcategoriesRepositoryImpl>(),
            )),
        BlocProvider(
          create: (context) => TransactionsCubit(
            transactionsRepository: context.read<TransactionsRepositoryImpl>(),
            categoriesRepository: context.read<CategoriesRepositoryImpl>(),
            subcategoriesRepository:
            context.read<SubcategoriesRepositoryImpl>(),
            accountsRepository: context.read<AccountsRepositoryImpl>(),
            filter: TransactionsViewFilter(
                type: TransactionsViewFilterTypes.allExpenses),
          ),
        ),
      ],
      child: isDisplayDesktop(context) ? HomeDesktopPage() : HomeMobilePage()
    );

  }
}
