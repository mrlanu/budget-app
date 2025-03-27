import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:qruto_budget/backup/backup.dart';
import 'package:qruto_budget/constants/constants.dart';
import 'package:qruto_budget/database/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'backup_state.dart';

class BackupCubit extends Cubit<BackupState> {
  BackupCubit({required AppDatabase database})
      : _database = database,
        super(BackupState(isAuthenticated: false));

  final AppDatabase _database;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [drive.DriveApi.driveFileScope, drive.DriveApi.driveAppdataScope],
  );

  static const _dbName = 'qruto_budget.sqlite';

  Future<void> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        final availableBackups = await fetchAvailableBackups();
        emit(BackupState(
            isAuthenticated: true,
            userName: account.displayName,
            userAvatar: account.photoUrl,
            userEmail: account.email,
            availableBackups: availableBackups,
            isAuthCheckingStatus: false));
      }
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
    ));
  }

  Future<void> checkUserStatus() async {
    emit(state.copyWith(isAuthCheckingStatus: true));
    final account = await _googleSignIn.signInSilently();
    if (account != null) {
      final availableBackups = await fetchAvailableBackups();
      emit(BackupState(
          isAuthenticated: true,
          userName: account.displayName,
          userAvatar: account.photoUrl,
          userEmail: account.email,
          availableBackups: availableBackups,
          isAuthCheckingStatus: false));
    } else {
      emit(state.copyWith(isAuthCheckingStatus: false));
    }
  }

  Future<bool> autoBackup() async {
    final account = await _googleSignIn.signInSilently();
    if (account != null) {
      final backups = await fetchAvailableBackups();
      await uploadBackupToDrive();
      if (backups.length >= Constants.maxBackups) {
        await deleteBackup(backups.last);
      }
      return true;
    }
    return false;
  }

  Future<bool> uploadBackupToDrive() async {
    emit(state.copyWith(isUploading: true));
    final driveApi = await _initializeDriveApi();
    final prefs = await SharedPreferences.getInstance();
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

    await driveApi.files.create(
      driveFile,
      uploadMedia: drive.Media(file.openRead(), file.lengthSync()),
    );
    await prefs.setString('last_backup_time', DateTime.now().toIso8601String());

    final availableBackups = await fetchAvailableBackups();
    emit(
        state.copyWith(availableBackups: availableBackups, isUploading: false));

    return true;
  }

  Future<bool> restoreBackup(String backupFileId) async {
    final driveApi = await _initializeDriveApi();

    final backupFile =
        await _downloadBackupFile(driveApi: driveApi, fileId: backupFileId);

    final backupImporterService = BackupImporterService(_database);
    await backupImporterService.importBackupFromFile(backupFile);

    await backupFile.delete();
    return true;
  }

  Future<File> _downloadBackupFile({
    required drive.DriveApi driveApi,
    required String fileId,
    String fileName = 'temp.sqlite',
  }) async {
    final dir = await getApplicationSupportDirectory();
    final file = File('${dir.path}/$fileName');

    final media = await driveApi.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    final sink = file.openWrite();
    await media.stream.pipe(sink);
    await sink.close();

    return file;
  }

  Future<List<drive.File>> fetchAvailableBackups() async {
    final driveApi = await _initializeDriveApi();
    final fileList = await driveApi.files.list(
        spaces: 'appDataFolder',
        q: "name contains 'backup'",
        orderBy: "createdTime desc",
        $fields: "files(id, name, createdTime)");

    if (fileList.files == null || fileList.files!.isEmpty) {
      print("No backup found.");
      return [];
    }

    return fileList.files!;
  }

  Future<bool> deleteBackup(drive.File file) async {
    final driveApi = await _initializeDriveApi();

    await driveApi.files.delete(file.id!);
    final availableBackups = await fetchAvailableBackups();

    //called in order to trigger auto backup when there is no one
    //BackgroundWorker.checkLastAutoBackup
    //dateLastAutoBackup == null
    if (availableBackups.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('last_backup_time');
    }
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
