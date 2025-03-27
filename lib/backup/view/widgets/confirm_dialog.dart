import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qruto_budget/utils/theme/cubit/theme_cubit.dart';

Future<void> showConfirmRestoreDialog(
    BuildContext context, VoidCallback onConfirm) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      final colors = context.read<ThemeCubit>().state;
      return AlertDialog(
        title: Text(
          'Restore Backup',
          style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'This will overwrite all existing data in your app.\n\nAre you sure you want to continue?',
          style: TextStyle(fontSize: 20.sp),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Cancel',
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.secondaryColor,
            ),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
          ),
        ],
      );
    },
  );
}
