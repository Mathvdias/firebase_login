import 'package:firebase_login/app/app.dart';
import 'package:firebase_login/home/home.dart';
import 'package:firebase_login/login/login.dart';
import 'package:flutter/widgets.dart';


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
