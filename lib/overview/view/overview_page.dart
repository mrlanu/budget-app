import 'package:budget_app/overview/bloc/overview_bloc.dart';
import 'package:budget_app/overview/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/bloc/app_bloc.dart';
import '../widgets/widgets.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({Key? key}) : super(key: key);

  final DummyRepository _repository = const DummyRepository();

  static Page<void> page() => const MaterialPage<void>(child: OverviewPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return OverviewBloc(repository: _repository)..add(LoadCategoriesEvent());
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Budget'),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                key: const Key('homePage_logout_iconButton'),
                icon: const Icon(Icons.exit_to_app),
                onPressed: () {
                  context.read<AppBloc>().add(const AppLogoutRequested());
                },
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Add your onPressed code here!
            },
            child: const Icon(Icons.add),
          ),
          drawer: Drawer(),
          body: BlocBuilder<OverviewBloc, OverviewState>(
            builder: (context, state) {
              return state.status == OverviewStatus.loading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: state.categoryList.length,
                      itemBuilder: (context, index) {
                        final category = state.categoryList[index];
                        return CategoryView(
                          icon: Icon(IconData(category.iconCodePoint,
                              fontFamily: 'MaterialIcons')),
                          title: category.name,
                          //subtitle: 'subtitle',
                          semanticsLabel: 'semanticsLabel',
                          amount: category.amount,
                          suffix: Icon(Icons.chevron_right),
                        );
                      });
            },
          )),
    );
  }
}
