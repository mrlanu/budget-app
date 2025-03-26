import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qruto_budget/backup/backup.dart';

class GoogleProfile extends StatelessWidget {
  const GoogleProfile({super.key, required this.state});

  final BackupState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 18.h, horizontal: 0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: state.userAvatar != null
              ? NetworkImage(state.userAvatar!)
              : AssetImage("assets/default_avatar.png")
          as ImageProvider,
        ),
        title: Text(
          state.userName ?? "No Name",
          style: TextStyle(
              fontSize: 22.sp, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          state.userEmail ?? "No Email",
          style: TextStyle(fontSize: 18.sp),
        ),
        trailing: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () =>
              context.read<BackupCubit>().signOut(),
        ),
      ),
    );
  }
}
