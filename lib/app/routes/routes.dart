import 'package:budget_app/overview/view/overview_page.dart';
import 'package:flutter/widgets.dart';
import 'package:budget_app/app/app.dart';
import 'package:budget_app/home/home.dart';
import 'package:budget_app/login/login.dart';

import '../../splash/splash.dart';

List<Page<dynamic>> onGenerateAppViewPages(
    AppStatus state,
    List<Page<dynamic>> pages,
    ) {
  switch (state) {
    case AppStatus.authenticated:
      //return [HomePage.page()];
      return[OverviewPage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
    case AppStatus.splash:
      return [SplashPage.page()];
  }
}
