part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final bool isAuthenticated;
  final String? userName;
  final String? userAvatar;
  final drive.DriveApi? driveApi;
  final List<drive.File> availableBackups;
  final bool isAuthCheckingStatus;
  final bool isUploading;

  AuthState({
    required this.isAuthenticated,
    this.userName,
    this.userAvatar,
    this.driveApi,
    this.availableBackups = const [],
    this.isAuthCheckingStatus = true,
    this.isUploading = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? Function()? userName,
    String? Function()? userAvatar,
    drive.DriveApi? Function()? driveApi,
    List<drive.File>? availableBackups,
    bool? isAuthCheckingStatus,
    bool? isUploading,
  }) {
    return AuthState(
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
