import 'package:budget_app/settings/view/widgets/theme_section.dart';
import 'package:budget_app/utils/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ThemeSection(),
          ],
        ),
      ),
    ));
  }
}
