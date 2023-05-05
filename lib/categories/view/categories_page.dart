import 'package:budget_app/categories/cubit/categories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/bloc/app_bloc.dart';
import '../../shared/shared.dart';
import '../../shared/widgets/entity_view_widget.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  static const routeName = '/categories';

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    final section =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Categories'),
      ),
      body: BlocProvider(
        create: (context) => CategoriesCubit(user)..fetchAllCategories(section['section']!),
        child: BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
            return state.status == DataStatus.loading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: state.categorySummaryList.length,
                    itemBuilder: (context, index) {
                      final cat = state.categorySummaryList[index];
                      return EntityView(
                        icon: Icon(IconData(cat.iconCodePoint,
                            fontFamily: 'MaterialIcons')),
                        title: cat.category.name,
                        routeName: cat.category.name,
                        //subtitle: 'subtitle',
                        amount: cat.amount,
                        suffix: Icon(Icons.chevron_right),
                        onTap: (){},
                      );
                    });
          },
        ),
      ),
    );
  }
}
