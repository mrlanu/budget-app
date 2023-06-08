import 'package:budget_app/app/app.dart';
import 'package:budget_app/categories/cubit/categories_cubit.dart';
import 'package:budget_app/categories/repository/categories_repository.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  static Route<void> route({required TransactionType transactionType}) {
    return MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return BlocProvider(
            create: (context) => CategoriesCubit(
                categoriesRepository: context.read<CategoriesRepositoryImpl>(),
                transactionType: transactionType)
              ..onInit(budgetId: context.read<AppBloc>().state.budget!.id),
            child: CategoriesPage(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return const CategoriesView();
  }
}

class CategoriesView extends StatelessWidget {
  const CategoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        return Container(
          color: scheme.background,
          child: SafeArea(
              child: Scaffold(
            appBar: AppBar(
              title: _buildTitle(state),
            ),
            body: Column(
              children: [
                Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      final category = state.categories[index];
                      return Card(
                        elevation: Theme.of(context).cardTheme.elevation,
                        child: ListTile(
                          title: Text(
                            category.name,
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .fontSize),
                          ),
                          leading: IconButton(
                            icon: Icon(Icons.highlight_remove,
                                color: Theme.of(context).colorScheme.error),
                            onPressed: () {
                              context.read<CategoriesCubit>().onCategoryDeleted(category);
                            },
                          ),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () {
                            context
                                .read<CategoriesCubit>()
                                .onCategoryEdit(category);
                            _openDialog(context);
                          },
                        ),
                      );
                    },
                  ),
                ),
                ListTile(
                  tileColor: scheme.secondaryContainer,
                  title: Text(
                    'New category',
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleLarge!.fontSize),
                  ),
                  trailing: Icon(
                    Icons.add,
                    color: scheme.onSecondaryContainer,
                  ),
                  onTap: () {
                    context.read<CategoriesCubit>().onNewCategory();
                    _openDialog(context);
                  },
                ),
              ],
            ),
          )),
        );
      },
    );
  }

  Future<String?> _openDialog(BuildContext context) => showDialog<String>(
      context: context,
      builder: (_) => BlocProvider.value(
          value: context.read<CategoriesCubit>(),
          child: BlocBuilder<CategoriesCubit, CategoriesState>(
            builder: (context, state) {
              return AlertDialog(
                title: Text(state.editCategory == null
                    ? 'Add category'
                    : 'Edit category'),
                content: TextFormField(
                  initialValue: state.editCategory?.name,
                  onChanged: (name) =>
                      context.read<CategoriesCubit>().onNameChanged(name),
                  decoration: InputDecoration(hintText: 'Enter name'),
                ),
                actions: [
                  TextButton(
                    onPressed: () => _submit(context),
                    child: Text('SAVE'),
                  )
                ],
              );
            },
          )));

  void _submit(BuildContext context) {
    final budgetId = context.read<AppBloc>().state.budget!.id;
    context.read<CategoriesCubit>().onSubmit(budgetId);
    Navigator.of(context).pop();
  }

  Widget _buildTitle(CategoriesState state) {
    final body = switch (state.transactionType) {
      TransactionType.EXPENSE => 'Expenses categories',
      TransactionType.INCOME => 'Income categories',
      TransactionType.TRANSFER => 'Transfer',
    TransactionType.ACCOUNT => 'Account categories',
    };
    return Text(body);
  }
}
