import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:note_keeper/presentation/pages/authentication/authentication.dart';
import 'package:note_keeper/presentation/pages/note/note.dart';

abstract class AppRoutes {
  static String get note => NotePage.routeName;
  static String get newNote => NewNote.routeName;
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
final routeLoggedIn = RouteMap(
  onUnknownRoute: (_) => const Redirect(NewNote.routeName),
  routes: {
    NewNote.routeName: (_) => const MaterialPage(child: NewNote()),
    '${NotePage.routeName}/:id': (info) {
      final docId = info.pathParameters['id'];
      if (docId == null) {
        return const Redirect(NewNote.routeName);
      }
      return MaterialPage(child: NotePage(documentId: docId));
    }
  },
);
