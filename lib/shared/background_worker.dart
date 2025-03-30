import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qruto_budget/backup/cubit/backup_cubit.dart';
import 'package:qruto_budget/shared/shared_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundWorker {
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
        SharedFunctions.showWhatsNewSheet(context);
      });

      // Update stored version
      await prefs.setString('last_opened_version', currentVersion);
    }
  }

  static Future<void> checkLastAutoBackup(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    final dateString = prefs.getString('last_backup_time');
    final dateLastAutoBackup =
        dateString != null ? DateTime.parse(dateString) : null;

    if (dateLastAutoBackup == null ||
        DateTime.now().difference(dateLastAutoBackup).inHours > 24) {
      final success = await context.read<BackupCubit>().autoBackup();
      if (success) {
        SharedFunctions.showSnackbar(
            context, true, 'Auto Backup !', 'Auto Backup has been uploaded.');
      }
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
}
