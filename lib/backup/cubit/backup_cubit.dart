import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

part 'backup_state.dart';

class BackupCubit extends Cubit<BackupState> {
  BackupCubit() : super(BackupState(isAuthenticated: false));

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [drive.DriveApi.driveFileScope, drive.DriveApi.driveAppdataScope],
  );

  static const _dbName = 'qruto_budget.sqlite';

  Future<void> signInAndGetDriveApi() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        final auth.AuthClient? client =
            await _googleSignIn.authenticatedClient();
        final driveApi = drive.DriveApi(client as http.Client);
        final availableBackups = await fetchAvailableBackups(driveApi);
        emit(BackupState(
            isAuthenticated: true,
            userName: account.displayName,
            userAvatar: account.photoUrl,
            driveApi: driveApi,
            availableBackups: availableBackups,
            isAuthCheckingStatus: false));
      }
      ;
    } catch (e) {
      print("Google Sign-In Error: $e");
      emit(BackupState(isAuthenticated: false));
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    emit(state.copyWith(
      isAuthenticated: false,
      userName: null,
      userAvatar: null,
      availableBackups: [],
      driveApi: null,
    ));
  }

  Future<void> checkUserStatus() async {
    emit(state.copyWith(isAuthCheckingStatus: true));
    final account = await _googleSignIn.signInSilently();
    if (account != null) {
      final driveApi = await _initializeDriveApi();
      final availableBackups = await fetchAvailableBackups(driveApi);
      emit(BackupState(
          isAuthenticated: true,
          userName: account.displayName,
          userAvatar: account.photoUrl,
          driveApi: driveApi,
          availableBackups: availableBackups,
          isAuthCheckingStatus: false));
    } else {
      emit(state.copyWith(isAuthCheckingStatus: false));
    }
  }

  Future<bool> uploadBackupToDrive() async {
    if (state.driveApi == null) {
      print("Google Drive is not authenticated.");
      return false;
    }

    emit(state.copyWith(isUploading: true));
    final dbPath = await _getDatabasePath();
    final file = File(dbPath!);

    if (!await file.exists()) {
      print("Database file not found");
      return false;
    }

    final timestamp =
        DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD

    final driveFile = drive.File()
      ..name = 'backup_$timestamp.sqlite'
      ..parents = ['appDataFolder'];

    await state.driveApi!.files.create(
      driveFile,
      uploadMedia: drive.Media(file.openRead(), file.lengthSync()),
    );

    final availableBackups = await fetchAvailableBackups(state.driveApi!);
    emit(
        state.copyWith(availableBackups: availableBackups, isUploading: false));

    return true;
  }

  Future<bool> restoreBackup(String fileId) async {
    if (state.driveApi == null) {
      print("Google Drive is not authenticated.");
      return false;
    }

    final response = await state.driveApi!.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    // Save the file to the local database path
    final dbPath = await _getDatabasePath();
    final dbFile = File(dbPath!);
    await response.stream.pipe(dbFile.openWrite());
    final availableBackups = await fetchAvailableBackups(state.driveApi!);
    emit(state.copyWith(availableBackups: availableBackups));
    print('Database downloaded from Google Drive');
    return true;
  }

  Future<List<drive.File>> fetchAvailableBackups(
      drive.DriveApi driveApi) async {
    final fileList = await driveApi.files.list(
        spaces: 'appDataFolder',
        q: "name contains 'backup_'",
        orderBy: "createdTime desc",
        $fields: "files(id, name, createdTime)");

    if (fileList.files == null || fileList.files!.isEmpty) {
      print("No backup found.");
      return [];
    }

    return fileList.files!;
  }

  Future<bool> deleteBackup(drive.File file) async {
    if (state.driveApi == null) {
      print("Google Drive authentication failed");
      return false;
    }

    await state.driveApi!.files.delete(file.id!);
    final availableBackups = await fetchAvailableBackups(state.driveApi!);
    emit(state.copyWith(availableBackups: availableBackups));
    return true;
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
