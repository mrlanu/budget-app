import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:qruto_budget/utils/theme/cubit/theme_cubit.dart';

import '../../backup/cubit/backup_cubit.dart';

class BackupPage extends StatelessWidget {
  const BackupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BackupPageView();
  }
}

class BackupPageView extends StatelessWidget {
  const BackupPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Backup', style: TextStyle(fontSize: 30.sp)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: BlocProvider(
        create: (context) => BackupCubit()..checkUserStatus(),
        child: ProfileContainer(),
      ),
    ));
  }
}

class ProfileContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BackupCubit, BackupState>(
      builder: (context, state) {
        final colors = context.read<ThemeCubit>().state;
        return state.isAuthCheckingStatus
            ? Center(
                child: CircularProgressIndicator(),
              )
            : state.isAuthenticated
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: state.userAvatar != null
                                    ? NetworkImage(state.userAvatar!)
                                    : AssetImage("assets/default_avatar.png")
                                        as ImageProvider,
                              ),
                              SizedBox(width: 10),
                              Text(
                                state.userName ?? "No Name",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.logout),
                                onPressed: () =>
                                    context.read<BackupCubit>().signOut(),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: state.availableBackups.length,
                              itemBuilder: (context, index) {
                                final file = state.availableBackups[index];
                                final date =
                                    DateFormat('MMM-dd-yyyy hh:mm:ss aaa')
                                        .format(file.createdTime!);
                                return Card(
                                  child: ListTile(
                                      title: Text(
                                        overflow: TextOverflow.ellipsis,
                                        '${file.name}'.split('.').first,
                                        style: TextStyle(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      subtitle: Text('$date'),
                                      leading: IconButton(
                                        icon: Icon(Icons.highlight_remove,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error),
                                        onPressed: () async {
                                          final success = await context
                                              .read<BackupCubit>()
                                              .deleteBackup(file);
                                          _showSnackbar(
                                              context,
                                              success,
                                              success ? 'Success !' : 'Ups !',
                                              success
                                                  ? 'Backup has been deleted.'
                                                  : 'Something went wrong.');
                                        },
                                      ),
                                      trailing: CircleAvatar(
                                        backgroundColor:
                                            colors.primaryColor[100],
                                        child: Icon(Icons.download),
                                      ),
                                      onTap: () async {
                                        final success = await context
                                            .read<BackupCubit>()
                                            .restoreBackup(file.id!);
                                        _showSnackbar(
                                            context,
                                            success,
                                            success ? 'Success !' : 'Ups !',
                                            success
                                                ? 'Backup has been restored.'
                                                : 'Something went wrong.');
                                      }),
                                );
                              },
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            backgroundColor: colors.secondaryColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 48, vertical: 14),
                          ),
                          onPressed: state.availableBackups.length >= 3
                              ? null
                              : () async {
                                  final success = await context
                                      .read<BackupCubit>()
                                      .uploadBackupToDrive();
                                  _showSnackbar(
                                      context,
                                      success,
                                      success ? 'Success !' : 'Ups !',
                                      success
                                          ? 'Backup has been uploaded.'
                                          : 'Something went wrong.');
                                },
                          child: SizedBox(
                            width: 300.w,
                            height: 60.h,
                            child: state.isUploading
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Center(
                                    child: Text(
                                      'Backup to Google Drive',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22.sp),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor:
                              context.read<ThemeCubit>().state.secondaryColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 48, vertical: 14),
                        ),
                        onPressed: () =>
                            context.read<BackupCubit>().signInAndGetDriveApi(),
                        child: SizedBox(
                          width: 290.w,
                          height: 50.h,
                          child: Center(
                            child: Text(
                              'Sign in with Google',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        )));
      },
    );
  }

  void _showSnackbar(
      BuildContext context, bool success, String title, String message) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: success ? ContentType.success : ContentType.failure,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
