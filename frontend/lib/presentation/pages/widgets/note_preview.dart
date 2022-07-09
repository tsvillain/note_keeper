import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart'
    show QuillController, Document;
import 'package:note_keeper/core/navigation/routes.dart';
import 'package:note_keeper/data/models/models.dart';
import 'package:routemaster/routemaster.dart';

class NotePreview extends StatefulWidget {
  final NoteModel note;
  const NotePreview({
    Key? key,
    required this.note,
  }) : super(key: key);

  @override
  State<NotePreview> createState() => _NotePreviewState();
}

class _NotePreviewState extends State<NotePreview> {
  late QuillController _controller;

  @override
  void initState() {
    _controller = QuillController(
      document: Document.fromJson(jsonDecode(widget.note.content)),
      selection: const TextSelection.collapsed(offset: 0),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Routemaster.of(context)
            .push("${AppRoutes.editNote}/${widget.note.docId}");
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: widget.note.title.isNotEmpty,
              child: Text(widget.note.title,
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            Visibility(
                visible: widget.note.title.isNotEmpty,
                child: const SizedBox(height: 12)),
            Text(_controller.plainTextEditingValue.text,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
