import 'package:flutter/material.dart';
import 'package:note_keeper/core/navigation/routes.dart';
import 'package:routemaster/routemaster.dart';

class NoteKeeper extends StatelessWidget {
  const NoteKeeper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: const RoutemasterParser(),
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        return routeLoggedOut;
      }),
    );
  }
}
