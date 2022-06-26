import 'package:flutter/material.dart';
import 'package:note_keeper/presentation/pages/authentication/login/login_page.dart';
import 'package:note_keeper/presentation/pages/authentication/register/register_page.dart';
import 'package:routemaster/routemaster.dart';

abstract class AppRoutes {
  // static String get note => NotePage.routeName;
  // static String get newNote => NewNotePage.routeName;
  static String get login => LoginPage.routeName;
  static String get register => RegisterPage.routeName;
}

final routeLoggedOut = RouteMap(
  onUnknownRoute: (_) => const Redirect(LoginPage.routeName),
  routes: {
    LoginPage.routeName: (_) => const MaterialPage(child: LoginPage()),
    RegisterPage.routeName: (_) => const MaterialPage(child: RegisterPage()),
  },
);
