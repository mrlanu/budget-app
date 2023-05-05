import 'package:budget_app/sections/cubit/sections_cubit.dart';
import 'package:budget_app/shared/shared.dart';
import 'package:budget_app/shared/widgets/entity_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/bloc/app_bloc.dart';
import '../../categories/view/categories_page.dart';

class SectionsPage extends StatelessWidget {
  const SectionsPage({Key? key}) : super(key: key);

  static const routeName = '/sections';

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SectionsPage());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return BlocProvider(
      create: (context) {
        return SectionsCubit(user)..fetchAllSections();
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
          body: BlocBuilder<SectionsCubit, SectionsState>(
            builder: (context, state) {
              return state.status == DataStatus.loading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: state.sectionSummaryList.length,
                      itemBuilder: (context, index) {
                        print('ICON CODE: ${Icons.wallet.codePoint}');
                        final section = state.sectionSummaryList[index];
                        return EntityView(
                          icon: Icon(IconData(section.iconCodePoint,
                              fontFamily: 'MaterialIcons')),
                          title: section.name,
                          routeName: section.name,
                          //subtitle: 'subtitle',
                          amount: section.amount,
                          suffix: Icon(Icons.chevron_right),
                          onTap: () => Navigator.of(context)
                              .pushNamed(CategoriesPage.routeName, arguments: {"section": section.name,}),
                        );
                      });
            },
          )),
    );
  }
}
