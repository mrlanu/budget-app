import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
    return SafeArea(child: Scaffold(
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
      body: ProfileContainer(),
    ));
  }
}

class ProfileContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (!state.isAuthenticated) {
          return Center(
            child: ElevatedButton(
              onPressed: () => context.read<AuthCubit>().signInAndGetDriveApi(),
              child: Text("Sign in with Google"),
            ),
          );
        }

        return Column(
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
                        : AssetImage("assets/default_avatar.png") as ImageProvider,
                  ),
                  SizedBox(width: 10),
                  Text(
                    state.userName ?? "No Name",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () => context.read<AuthCubit>().signOut(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.read<AuthCubit>().uploadBackupToDrive(),
              child: Text("Upload Backup to Google Drive"),
            ),
            ElevatedButton(
              onPressed: () => context.read<AuthCubit>().restoreLatestBackup(),
              child: Text("Restore Backup from Google Drive"),
            ),
          ],
        );
      },
    );
  }
}


