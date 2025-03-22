import 'package:qruto_budget/constants/changelog.dart';
import 'package:qruto_budget/utils/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateChecker {

  static Future<void> checkForUpdate(BuildContext context) async {
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        _showUpdateBottomSheet(context);
      }
    } catch (e) {
      print("Error checking for update: $e");
    }
  }

  static Future<void> checkIfUpdated(BuildContext context) async {
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

  static void _showUpdateBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false, // Force user to interact
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/update.png", height: 120),
            SizedBox(height: 10),
            Text(
              "New Update Available!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "We've added new features and fixed some bugs. Update now for the best experience!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await InAppUpdate.performImmediateUpdate();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),
              child: Text("Update Now",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Remind me later"),
            ),
          ],
        ),
      ),
    );
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
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 40),
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("What's New",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...changelog.map((item) {
                        final isTitle =
                            (item['titles'] as List<dynamic>).isNotEmpty;
                        final isAdded =
                            (item['added'] as List<dynamic>).isNotEmpty;
                        final isFixed =
                            (item['fixed'] as List<dynamic>).isNotEmpty;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 8),
                              // Padding inside the box
                              decoration: BoxDecoration(
                                color: prColor[100], // Background color
                                borderRadius:
                                    BorderRadius.circular(8), // Rounded corners
                              ),
                              child: Text(
                                item['version'] as String,
                                // Assuming `item` has a `version` field
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                            ),
                            Text(
                              item['date'] as String,
                              // Assuming `item` has a `version` field
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(height: 15,),
                            isTitle
                                ? RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                            height: 1.5,
                                            fontSize: 20,
                                            color: Colors.black),
                                        children: (item['titles']
                                                as List<String>)
                                            .map<TextSpan>((change) =>
                                                TextSpan(text: '$change\n'))
                                            .toList()),
                                  )
                                : Container(),
                            isAdded
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Added:',
                                          // Assuming `item` has a `version` field
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  height: 1.5),
                                              children: (item['added']
                                                      as List<String>)
                                                  .map<TextSpan>((change) =>
                                                      TextSpan(
                                                          text: ' - $change\n'))
                                                  .toList())),
                                    ],
                                  )
                                : Container(),
                            isFixed
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Fixed:',
                                        // Assuming `item` has a `version` field
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                  height: 1.5,
                                                  fontSize: 20,
                                                  color: Colors.black),
                                              children: (item['fixed']
                                                      as List<String>)
                                                  .map<TextSpan>((change) =>
                                                      TextSpan(
                                                          text: ' - $change\n'))
                                                  .toList()))
                                    ],
                                  )
                                : Container(),
                            Divider(),
                            SizedBox(height: 15),
                          ],
                        );
                      }),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
