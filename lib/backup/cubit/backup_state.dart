part of 'backup_cubit.dart';

class BackupState extends Equatable {
  final bool isAuthenticated;
  final String? userName;
  final String? userAvatar;
  final String? userEmail;
  final List<drive.File> availableBackups;
  final bool isAuthCheckingStatus;
  final bool isUploading;

  BackupState({
    required this.isAuthenticated,
    this.userName,
    this.userAvatar,
    this.userEmail,
    this.availableBackups = const [],
    this.isAuthCheckingStatus = true,
    this.isUploading = false,
  });

  BackupState copyWith({
    bool? isAuthenticated,
    String? Function()? userName,
    String? Function()? userAvatar,
    String? Function()? userEmail,
    List<drive.File>? availableBackups,
    bool? isAuthCheckingStatus,
    bool? isUploading,
  }) {
    return BackupState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userName: userName != null ? userName() : this.userName,
      userAvatar: userAvatar != null ? userAvatar() : this.userAvatar,
      userEmail: userEmail != null ? userEmail() : this.userEmail,
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
        userEmail,
        availableBackups,
        isAuthCheckingStatus,
        isUploading,
      ];
}
