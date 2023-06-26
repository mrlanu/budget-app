import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final scheme = Theme.of(context).colorScheme;
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
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          appBar: AppBar(
            backgroundColor: scheme.primaryContainer,
            title: _buildTitle(state.category!),
          ),
          body: Column(
            children: [
              SizedBox(
                height: 50.h,
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
                tileColor: scheme.primaryContainer,
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
                  autofocus: true,
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
    context.read<SubcategoriesCubit>().onSubmit();
    Navigator.of(context).pop();
  }

  Widget _buildTitle(Category category) {
    final body = 'Subcategories for ${category.name}';
    return Text(body);
  }
}
