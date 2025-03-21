import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:path_provider/path_provider.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState(isAuthenticated: false));

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [drive.DriveApi.driveFileScope, drive.DriveApi.driveAppdataScope],
  );

  static const _dbName = 'qruto_budget.sqlite';

  Future<void> signInAndGetDriveApi() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        final auth.AuthClient? client = await _googleSignIn.authenticatedClient();
        final driveApi = drive.DriveApi(client as http.Client);
        emit(AuthState(
          isAuthenticated: true,
          userName: account.displayName,
          userAvatar: account.photoUrl,
          driveApi: driveApi,
        ));
      }
      ;
    } catch (e) {
      print("Google Sign-In Error: $e");
      emit(AuthState(isAuthenticated: false));
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    emit(AuthState(isAuthenticated: false, driveApi: null));
  }

  Future<void> checkUserStatus() async {
    final account = await _googleSignIn.signInSilently();
    if (account != null) {
      final driveApi = await _initializeDriveApi();
      emit(AuthState(
        isAuthenticated: true,
        userName: account.displayName,
        userAvatar: account.photoUrl,
        driveApi: driveApi,
      ));
    }
  }

  Future<void> uploadBackupToDrive() async {
    if (state.driveApi == null) {
      print("Google Drive is not authenticated.");
      return;
    }

    final dbPath = await _getDatabasePath();
    final file = File(dbPath!);

    if (!await file.exists()) {
      print("Database file not found");
      return;
    }

    final timestamp = DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD

    final driveFile = drive.File()
      ..name = 'qruto_backup_$timestamp.sqlite'
      ..parents = ['appDataFolder'];

    await state.driveApi!.files.create(
      driveFile,
      uploadMedia: drive.Media(file.openRead(), file.lengthSync()),
    );

    print("Backup uploaded successfully: qruto_backup_$timestamp.sqlite");
  }

  Future<void> restoreLatestBackup() async {
    if (state.driveApi == null) {
      print("Google Drive is not authenticated.");
      return;
    }

    final fileList = await state.driveApi!.files.list(
      spaces: 'appDataFolder',
      q: "name contains 'qruto_backup_'",
      orderBy: "createdTime desc",
    );

    if (fileList.files == null || fileList.files!.isEmpty) {
      print("No backup found.");
      return;
    }

    // Download the file
    final latestBackup = fileList.files!.first;
    print("Restoring backup: ${latestBackup.name}");

    final fileId = fileList.files!.first.id!;
    final response = await state.driveApi!.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    // Save the file to the local database path
    final dbPath = await _getDatabasePath();
    final dbFile = File(dbPath!);
    await response.stream.pipe(dbFile.openWrite());

    print('Database downloaded from Google Drive');
  }

  Future<void> deleteOldBackups(String folderId) async {
    if (state.driveApi == null) {
      print("Google Drive authentication failed");
      return;
    }

    final fileList = await state.driveApi!.files.list(
      spaces: 'appDataFolder',
      q: "name contains 'qruto_backup_'",
      orderBy: "createdTime desc",
    );

    if (fileList.files == null || fileList.files!.length <= 7) {
      print("No need to delete backups. Less than 7 exist.");
      return;
    }

    // Keep only the latest 7 backups, delete the rest
    for (int i = 7; i < fileList.files!.length; i++) {
      final fileId = fileList.files![i].id!;
      await state.driveApi!.files.delete(fileId);
      print("Deleted old backup: ${fileList.files![i].name}");
    }
  }


  Future<String?> _getDatabasePath() async {
    final directory = await getApplicationSupportDirectory();
    return '${directory.path}/$_dbName';
  }

  Future<drive.DriveApi> _initializeDriveApi() async {
    final auth.AuthClient? client = await _googleSignIn.authenticatedClient();
    return drive.DriveApi(client as http.Client);
  }
}
