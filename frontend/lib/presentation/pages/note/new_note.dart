import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/provider.dart';

class NewNote extends ConsumerStatefulWidget {
  static const String routeName = "/newNote";
  const NewNote({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewNoteState();
}

class _NewNoteState extends ConsumerState<NewNote> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            ref.read(AppState.auth.notifier).signOut();
          },
          child: const Text('Sign Out')),
    );
  }
}
