part of 'auth_cubit.dart';

class AuthState extends Equatable{
  final bool isAuthenticated;
  final String? userName;
  final String? userAvatar;
  final drive.DriveApi? driveApi;

  AuthState({
    required this.isAuthenticated,
    this.userName,
    this.userAvatar,
    this.driveApi,
  });

  @override
  List<Object?> get props => [isAuthenticated, userName, userAvatar, driveApi,];
}

