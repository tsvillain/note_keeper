import 'package:flutter/material.dart';
import 'package:note_keeper/note_keeper.dart';

class Messenger {
  static showSnackbar(String text) {
    globalScaffold.currentState?.clearSnackBars();
    globalScaffold.currentState?.showSnackBar(SnackBar(
      content: Text(text),
      dismissDirection: DismissDirection.down,
      duration: const Duration(seconds: 2),
    ));
  }
}
