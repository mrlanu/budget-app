import 'package:budget_app/utils/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            Padding(
              padding:
                  const EdgeInsets.only(top: 15.0, left: 15.0, bottom: 4.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Theme',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(color: themeState.primaryColor[900])),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Card(
                child: ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.circleHalfStroke,
                    color: themeState.primaryColor[900],
                    size: 36,
                  ),
                  title: Text('Theme Mode',
                      style: Theme.of(context).textTheme.titleLarge!),
                  subtitle: Text('Select a theme mode'),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Card(
                child: ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.palette,
                    color: themeState.primaryColor[900],
                    size: 36,
                  ),
                  title: Text('Accent color',
                      style: Theme.of(context).textTheme.titleLarge!),
                  subtitle: Text('Select a color for interface'),
                  onTap: () => _showModalBottomSheet(context),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return _BottomSheetContent();
      },
    );
  }
}

class _BottomSheetContent extends StatelessWidget {
  const _BottomSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.count(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
          crossAxisCount: 3,
          children: List.generate(
            9, // Total number of containers (3x2 grid)
            (index) {
              return Center(
                child: GestureDetector(
                  onTap: () {
                    print('VALUE: ${appAccentColors[index].value}');
                    context
                      .read<ThemeCubit>()
                      .updateTheme(appAccentColors[index]);},
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          appAccentColors[index], // Change the color as needed
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }
}
