import 'package:budget_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../categories/models/category.dart';
import '../cubit/subcategories_cubit.dart';
import '../repository/subcategories_repository.dart';

class SubcategoriesPage extends StatelessWidget {
  const SubcategoriesPage({Key? key}) : super(key: key);

  static Route<void> route({required Category category}) {
    return MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return BlocProvider(
            create: (context) => SubcategoriesCubit(
                subcategoriesRepository: context.read<SubcategoriesRepositoryImpl>(),
                category: category)
              ..onInit(budgetId: context.read<AppBloc>().state.budget!.id, category: category),
            child: SubcategoriesPage(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return const SubcategoriesView();
  }
}

class SubcategoriesView extends StatelessWidget {
  const SubcategoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<SubcategoriesCubit, SubcategoriesState>(
      builder: (context, state) {
        return Container(
          color: scheme.background,
          child: SafeArea(
              child: Scaffold(
            appBar: AppBar(
              title: _buildTitle(state.category!),
            ),
            body: Column(
              children: [
                Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.subcategories.length,
                    itemBuilder: (context, index) {
                      final subcategory = state.subcategories[index];
                      return ListTile(
                        title: Text(
                          subcategory.name,
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
                            context.read<SubcategoriesCubit>().onSubcategoryDeleted(subcategory);
                          },
                        ),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          context
                              .read<SubcategoriesCubit>()
                              .onSubcategoryEdit(subcategory);
                          _openDialog(context);
                        },
                      );
                    },
                  ),
                ),
                ListTile(
                  tileColor: scheme.secondaryContainer,
                  title: Text(
                    'New Subcategory',
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleLarge!.fontSize),
                  ),
                  trailing: Icon(
                    Icons.add,
                    color: scheme.onSecondaryContainer,
                  ),
                  onTap: () {
                    context.read<SubcategoriesCubit>().onNewSubcategory();
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
          value: context.read<SubcategoriesCubit>(),
          child: BlocBuilder<SubcategoriesCubit, SubcategoriesState>(
            builder: (context, state) {
              return AlertDialog(
                title: Text(state.editSubcategory == null
                    ? 'Add subcategory'
                    : 'Edit subcategory'),
                content: TextFormField(
                  initialValue: state.editSubcategory?.name,
                  onChanged: (name) =>
                      context.read<SubcategoriesCubit>().onNameChanged(name),
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
    context.read<SubcategoriesCubit>().onSubmit(budgetId);
    Navigator.of(context).pop();
  }

  Widget _buildTitle(Category category) {
    final body = 'Subcategories for ${category.name}';
    return Text(body);
  }
}
