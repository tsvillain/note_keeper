import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotePage extends ConsumerStatefulWidget {
  static const String routeName = "/note";
  final String documentId;
  const NotePage({Key? key, required this.documentId}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotePageState();
}

class _NotePageState extends ConsumerState<NotePage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(widget.documentId));
  }
}
