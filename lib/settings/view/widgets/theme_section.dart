import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../utils/theme/cubit/theme_cubit.dart';

class ThemeSection extends StatelessWidget {
  const ThemeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return Column(children: [
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
            trailing: _ThemeModeButton(),
            /*IconButton(
                      key: const Key('homePage_deleteBudget'),
                      icon: const Icon(Icons.delete_forever),
                      onPressed: () {
                        context.read<HomeCubit>().deleteBudget();
                      },
                    ),*/
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
    ],);
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

enum _Modes { system, light, dark }

class _ThemeModeButton extends StatefulWidget {
  const _ThemeModeButton();

  @override
  State<_ThemeModeButton> createState() => _ThemeModeButtonState();
}

class _ThemeModeButtonState extends State<_ThemeModeButton> {
  _Modes? selectedItem;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_Modes>(
      icon: FaIcon(
        FontAwesomeIcons.bars,
      ),
      initialValue: selectedItem,
      onSelected: (_Modes item) {
        setState(() {
          selectedItem = item;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<_Modes>>[
        PopupMenuItem<_Modes>(
          onTap: () => context.read<ThemeCubit>().updateMode(0),
          value: _Modes.system,
          child: Text('System'),
        ),
        PopupMenuItem<_Modes>(
          onTap: () => context.read<ThemeCubit>().updateMode(1),
          value: _Modes.light,
          child: Text('Light'),
        ),
        PopupMenuItem<_Modes>(
          onTap: () => context.read<ThemeCubit>().updateMode(2),
          value: _Modes.dark,
          child: Text('Dark'),
        ),
      ],
    );
  }
}

class _BottomSheetContent extends StatelessWidget {
  const _BottomSheetContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.count(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
          crossAxisCount: 3,
          children: List.generate(
            9,
                (index) {
              return Center(
                child: GestureDetector(
                  onTap: () {
                    context
                        .read<ThemeCubit>()
                        .updateTheme(appAccentColors[index]);
                  },
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
