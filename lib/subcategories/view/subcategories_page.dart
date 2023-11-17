import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../categories/models/category.dart';
import '../../constants/colors.dart';
import '../../utils/utils.dart';
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
                subcategoriesRepository:
                    context.read<SubcategoriesRepositoryImpl>(),
                category: category)
              ..onInit(category: category),
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
    return BlocConsumer<SubcategoriesCubit, SubcategoriesState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == SubcategoriesStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
              ),
            );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: _buildTitle(state.category!),
          ),
          body: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.subcategories.length,
                  itemBuilder: (context, index) {
                    final subcategory = state.subcategories[index];
                    return Card(
                      elevation: Theme.of(context).cardTheme.elevation,
                      child: ListTile(
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
                            context
                                .read<SubcategoriesCubit>()
                                .onSubcategoryDeleted(subcategory);
                          },
                        ),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          context
                              .read<SubcategoriesCubit>()
                              .onSubcategoryEdit(subcategory);
                          _openDialog(context);
                        },
                      ),
                    );
                  },
                ),
              ),
              ListTile(
                tileColor: BudgetTheme.isDarkMode(context)
                  ? BudgetColors.accentDark
                  : BudgetColors.accent,
                title: Text(
                  'New Subcategory',
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleLarge!.fontSize),
                ),
                trailing: Icon(
                  Icons.add,
                  color:BudgetColors.primary,
                ),
                onTap: () {
                  context.read<SubcategoriesCubit>().onNewSubcategory();
                  _openDialog(context);
                },
              ),
            ],
          ),
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
                    : 'Edit subcategory', style: Theme.of(context).textTheme.titleLarge,),
                content: TextFormField(
                  autofocus: true,
                  initialValue: state.editSubcategory?.name,
                  onChanged: (name) =>
                      context.read<SubcategoriesCubit>().onNameChanged(name),
                  decoration: InputDecoration(hintText: 'Enter name'),
                ),
                actions: [
                  TextButton(
                    onPressed: () => _submit(context),
                    child: Text('SAVE', style: Theme.of(context).textTheme.titleMedium,),
                  )
                ],
              );
            },
          )));

  void _submit(BuildContext context) {
    context.read<SubcategoriesCubit>().onSubmit();
    Navigator.of(context).pop();
  }

  Widget _buildTitle(Category category) {
    final body = 'Subcategories for ${category.name}';
    return Text(body);
  }
}
