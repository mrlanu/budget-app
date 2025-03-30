import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:qruto_budget/backup/backup.dart';

import '../../../shared/shared_functions.dart';
import '../../../utils/theme/cubit/theme_cubit.dart';

class BackupsList extends StatelessWidget {
  const BackupsList({super.key, required this.state});

  final BackupState state;

  @override
  Widget build(BuildContext context) {
    final colors = context.read<ThemeCubit>().state;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<BackupCubit, BackupState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.availableBackups.length,
            itemBuilder: (context, index) {
              final file = state.availableBackups[index];
              final date = DateFormat('MMM-dd-yyyy hh:mm:ss aaa')
                  .format(file.createdTime!.toLocal());
              return Card(
                child: ListTile(
                  title: Text(
                    overflow: TextOverflow.ellipsis,
                    '${file.name}'.split('.').first,
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('$date'),
                  leading: IconButton(
                    icon: Icon(Icons.highlight_remove,
                        color: Theme.of(context).colorScheme.error),
                    onPressed: () async {
                      final success =
                          await context.read<BackupCubit>().deleteBackup(file);
                      SharedFunctions.showSnackbar(
                          context,
                          success,
                          success ? 'Success !' : 'Ups !',
                          success
                              ? 'Backup has been deleted.'
                              : 'Something went wrong.');
                    },
                  ),
                  trailing: CircleAvatar(
                    backgroundColor: colors.primaryColor[100],
                    child: Icon(Icons.download),
                  ),
                  onTap: () async {
                    await showConfirmRestoreDialog(
                      context,
                      () async {
                        final success = await context
                            .read<BackupCubit>()
                            .restoreBackup(file.id!);
                        SharedFunctions.showSnackbar(
                            context,
                            success,
                            success ? 'Success !' : 'Ups !',
                            success
                                ? 'Backup has been restored.'
                                : 'Something went wrong.');
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
