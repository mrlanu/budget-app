import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qruto_budget/settings/view/widgets/theme_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../database/database.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Settings', style: TextStyle(fontSize: 30.sp)),
            FutureBuilder(
              future: Future<(String, int)>(
                () async {
                  final (version, schema) = await Future.wait([
                    PackageInfo.fromPlatform(),
                    context.read<AppDatabase>().getSchemaVersion()
                  ]).then(
                    (result) =>
                        ((result[0] as PackageInfo).version, result[1] as int),
                  );
                  return (version, schema);
                },
              ),
              builder: (context, snapshot) {
                return Container(
                    child: snapshot.hasData
                        ? Text(
                            'v${snapshot.data?.$1}, schema: ${snapshot.data?.$2}',
                            style: TextStyle(fontSize: 18.sp),
                          )
                        : SizedBox());
              },
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ThemeSection(),
          ],
        ),
      ),
    ));
  }
}
