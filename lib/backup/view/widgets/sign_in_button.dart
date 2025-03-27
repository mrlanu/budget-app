import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/theme/cubit/theme_cubit.dart';
import '../../cubit/backup_cubit.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor:
              context.read<ThemeCubit>().state.secondaryColor,
              padding: const EdgeInsets.symmetric(
                  horizontal: 48, vertical: 14),
            ),
            onPressed: () => context.read<BackupCubit>().signIn(),
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
  }
}
