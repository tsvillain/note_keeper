import 'package:flutter/material.dart';
import 'package:note_keeper/presentation/pages/pages.dart';
import 'package:routemaster/routemaster.dart';

abstract class AppRoutes {
  static String get editNote => EditNotePage.routeName;
  static String get login => LoginPage.routeName;
  static String get register => RegisterPage.routeName;
  static String get home => HomePage.routeName;
  static String get setting => SettingPage.routeName;
}

final routeLoggedOut = RouteMap(
  onUnknownRoute: (_) => const Redirect(LoginPage.routeName),
  routes: {
    LoginPage.routeName: (_) => const MaterialPage(child: LoginPage()),
    RegisterPage.routeName: (_) => const MaterialPage(child: RegisterPage()),
  },
);
final routeLoggedIn = RouteMap(
  onUnknownRoute: (_) => const Redirect(HomePage.routeName),
  routes: {
    HomePage.routeName: (_) => const MaterialPage(child: HomePage()),
    '${EditNotePage.routeName}/:id': (info) {
      final docId = info.pathParameters['id'];
      // if `docId` is null then New Note.
      return MaterialPage(child: EditNotePage(noteId: docId));
    },
    EditNotePage.routeName: (_) =>
        const MaterialPage(child: EditNotePage(noteId: null)),
    SettingPage.routeName: (_) => const MaterialPage(child: SettingPage()),
  },
);
