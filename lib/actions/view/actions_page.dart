import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:qruto_budget/utils/theme/cubit/theme_cubit.dart';

import '../../backup/cubit/auth_cubit.dart';

class ActionsPage extends StatelessWidget {
  const ActionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ActionsPageView();
  }
}

class ActionsPageView extends StatelessWidget {
  const ActionsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Actions', style: TextStyle(fontSize: 36.sp)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: BlocProvider(
        create: (context) => AuthCubit()..checkUserStatus(),
        child: ProfileContainer(),
      ),
    ));
  }
}

class ProfileContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
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
                                    context.read<AuthCubit>().signOut(),
                              ),
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
                                        '${file.name}',
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
                                              .read<AuthCubit>()
                                              .deleteCertainBackup(file);
                                          final snackBar = SnackBar(
                                            elevation: 0,
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Colors.transparent,
                                            content: AwesomeSnackbarContent(
                                              title: success
                                                  ? 'Success !'
                                                  : 'Ups !',
                                              message: success
                                                  ? 'Backup has been deleted !'
                                                  : 'Something went wrong.',
                                              contentType: success
                                                  ? ContentType.success
                                                  : ContentType.failure,
                                            ),
                                          );

                                          ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(snackBar);
                                        },
                                      ),
                                      trailing: CircleAvatar(
                                        backgroundColor:
                                            colors.primaryColor[100],
                                        child: Icon(Icons.download),
                                      ),
                                      onTap: () async {
                                        final success = await context
                                            .read<AuthCubit>()
                                            .restoreCertainBackup(file.id!);
                                        final snackBar = SnackBar(
                                          elevation: 0,
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.transparent,
                                          content: AwesomeSnackbarContent(
                                            title:
                                                success ? 'Success !' : 'Ups !',
                                            message: success
                                                ? 'Database downloaded from Google Drive !'
                                                : 'Something went wrong.',
                                            contentType: success
                                                ? ContentType.success
                                                : ContentType.failure,
                                          ),
                                        );

                                        ScaffoldMessenger.of(context)
                                          ..hideCurrentSnackBar()
                                          ..showSnackBar(snackBar);
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
                          onPressed: () async {
                            final success = await context
                                .read<AuthCubit>()
                                .uploadBackupToDrive();
                            final snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: success ? 'Success !' : 'Ups !',
                                message: success
                                    ? 'Backup uploaded successfully !'
                                    : 'Backup failed.',
                                contentType: success
                                    ? ContentType.success
                                    : ContentType.failure,
                              ),
                            );

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
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
                                          fontSize: 26.sp),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: ElevatedButton(
                      onPressed: () =>
                          context.read<AuthCubit>().signInAndGetDriveApi(),
                      child: Text("Sign in with Google"),
                    ),
                  );
      },
    );
  }
}
