part of 'backup_cubit.dart';

class BackupState extends Equatable {
  final bool isAuthenticated;
  final String? userName;
  final String? userAvatar;
  final drive.DriveApi? driveApi;
  final List<drive.File> availableBackups;
  final bool isAuthCheckingStatus;
  final bool isUploading;

  BackupState({
    required this.isAuthenticated,
    this.userName,
    this.userAvatar,
    this.driveApi,
    this.availableBackups = const [],
    this.isAuthCheckingStatus = true,
    this.isUploading = false,
  });

  BackupState copyWith({
    bool? isAuthenticated,
    String? Function()? userName,
    String? Function()? userAvatar,
    drive.DriveApi? Function()? driveApi,
    List<drive.File>? availableBackups,
    bool? isAuthCheckingStatus,
    bool? isUploading,
  }) {
    return BackupState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userName: userName != null ? userName() : this.userName,
      userAvatar: userAvatar != null ? userAvatar() : this.userAvatar,
      driveApi: driveApi != null ? driveApi() : this.driveApi,
      availableBackups: availableBackups ?? this.availableBackups,
      isAuthCheckingStatus: isAuthCheckingStatus ?? this.isAuthCheckingStatus,
      isUploading: isUploading ?? this.isUploading,
    );
  }

  @override
  List<Object?> get props => [
        isAuthenticated,
        userName,
        userAvatar,
        driveApi,
        availableBackups,
        isAuthCheckingStatus,
        isUploading,
      ];
}
