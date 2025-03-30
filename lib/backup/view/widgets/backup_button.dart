import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/constants.dart';
import '../../../shared/shared_snackbar.dart';
import '../../../utils/theme/cubit/theme_cubit.dart';
import '../../cubit/backup_cubit.dart';

class BackupButton extends StatelessWidget {
  const BackupButton({super.key, required this.state});

  final BackupState state;

  @override
  Widget build(BuildContext context) {
    final colors = context.read<ThemeCubit>().state;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: colors.secondaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
      ),
      onPressed: state.availableBackups.length >= Constants.maxBackups
          ? null
          : () async {
              final success =
                  await context.read<BackupCubit>().uploadBackupToDrive();
              SharedFunctions.showSnackbar(
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
    );
  }
}
