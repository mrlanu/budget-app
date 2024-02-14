import 'package:budget_app/home/view/home_page.dart';
import 'package:budget_app/login/view/login_page.dart';
import 'package:flutter/widgets.dart';

import '../app/bloc/app_bloc.dart';

List<Page<dynamic>> onGenerateAppViewPages(
    AppStatus state,
    List<Page<dynamic>> pages,
    ) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}
