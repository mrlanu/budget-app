import 'package:budget_app/constants/changelog.dart';
import 'package:budget_app/utils/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateChecker {
  static Future<void> checkForUpdate(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final packageInfo = await PackageInfo.fromPlatform();

    final currentVersion = packageInfo.version;
    final lastVersion = prefs.getString('last_opened_version') ?? "0.0.0";

    if (currentVersion != lastVersion) {
      // Show the bottom sheet
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showWhatsNewSheet(context);
      });

      // Update stored version
      await prefs.setString('last_opened_version', currentVersion);
    }
  }

  static void _showWhatsNewSheet(BuildContext context) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        final prColor = context.read<ThemeCubit>().state.primaryColor;
        return Container(
          height: 600,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 50),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("What's New",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...changelog.map((item) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8), // Padding inside the box
                                decoration: BoxDecoration(
                                  color: prColor[100], // Background color
                                  borderRadius: BorderRadius.circular(8), // Rounded corners
                                ),
                                child: Text(
                                  item['version'] as String,
                                  // Assuming `item` has a `version` field
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                              ),
                              Text(
                                item['date'] as String,
                                // Assuming `item` has a `version` field
                                style: TextStyle(
                                    fontSize: 12),
                              ),
                              SizedBox(height: 15),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  children: (item['changes'] as List<String>)
                                      .map<TextSpan>((change) =>
                                          TextSpan(text: ' - $change\n'))
                                      .toList(),
                                ),
                              ),
                              SizedBox(height: 10),
                              Divider(),
                              SizedBox(height: 15),
                            ],
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
