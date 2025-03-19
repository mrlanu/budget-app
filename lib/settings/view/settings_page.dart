import 'package:budget_app/settings/view/widgets/theme_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(fontSize: 36.sp)),
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
