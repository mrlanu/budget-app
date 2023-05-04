import 'package:budget_app/overview/bloc/overview_bloc.dart';
import 'package:budget_app/overview/repository/repository.dart';
import 'package:budget_app/shared/widgets/entity_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/bloc/app_bloc.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({Key? key}) : super(key: key);

  final DummyRepository _repository = const DummyRepository();

  static const routeName = '/overview';

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const OverviewPage());
  }

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
          drawer: Drawer(),
          body: BlocBuilder<OverviewBloc, OverviewState>(
            builder: (context, state) {
              return state.status == OverviewStatus.loading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: state.categoryList.length,
                      itemBuilder: (context, index) {
                        final category = state.categoryList[index];
                        return EntityView(
                          icon: Icon(IconData(category.iconCodePoint,
                              fontFamily: 'MaterialIcons')),
                          title: category.name,
                          routeName: category.routeName,
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
