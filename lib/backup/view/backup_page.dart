import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qruto_budget/backup/backup.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  @override
  Widget build(BuildContext context) {
    return const BackupPageView();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<BackupCubit>().checkUserStatus();
    });
  }
}

class BackupPageView extends StatelessWidget {
  const BackupPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: BlocBuilder<BackupCubit, BackupState>(
          builder: (context, state) {
            return state.isAuthCheckingStatus
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : state.isAuthenticated
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 25.0),
                        child: Column(
                          children: [
                            GoogleProfile(state: state),
                            Expanded(child: BackupsList(state: state)),
                            BackupButton(state: state)
                          ],
                        ),
                      )
                    : SignInButton();
          },
        ));
  }
}
