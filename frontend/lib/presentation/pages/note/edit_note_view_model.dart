import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/provider.dart';
import 'package:note_keeper/data/models/note.dart';
import 'package:note_keeper/data/repositories/respositories.dart';
import 'package:note_keeper/presentation/base_view_model.dart';

final _editNoteViewModel = ChangeNotifierProvider(
    (ref) => EditNoteViewModel(ref.read(Repository.database)));

mixin EditNoteView {}

class EditNoteViewModel extends BaseViewModel<EditNoteView> {
  EditNoteViewModel(this._databaseRepository);

  static ChangeNotifierProvider<EditNoteViewModel> get provider =>
      _editNoteViewModel;

  final DatabaseRepository _databaseRepository;

  final TextEditingController titleTextEditingController =
      TextEditingController();

  late final QuillController richContentTextEditingController;

  bool isNewNote = false;

  NoteModel? _existingNote;

  @override
  void dispose() {
    titleTextEditingController.dispose();
    richContentTextEditingController.dispose();
    super.dispose();
  }

  /// Fetch and store the existing Note if noteID is shared
  /// init's QuillController
  Future<void> initAfterLoad({String? noteID}) async {
    try {
      toggleLoadingOn(true);
      if (noteID != null) {
        isNewNote = false;
        _existingNote = await _databaseRepository.getNoteByID(noteID: noteID);
        titleTextEditingController.text = _existingNote!.title;
        richContentTextEditingController = QuillController(
          document: Document.fromJson(jsonDecode(_existingNote!.content)),
          selection: const TextSelection.collapsed(offset: 0),
        );
      } else {
        isNewNote = true;
        richContentTextEditingController = QuillController.basic();
      }
    } catch (_) {
    } finally {
      toggleLoadingOn(false);
    }
  }

  /// Create a new Note or update the existing Note
  Future<void> saveNote() async {
    if (isNewNote) {
      await _databaseRepository.createNote(
        title: titleTextEditingController.text,
        content: jsonEncode(
            richContentTextEditingController.document.toDelta().toJson()),
      );
    } else if (_existingNote != null) {
      await _databaseRepository.updateNote(
        docId: _existingNote!.docId!,
        title: titleTextEditingController.text,
        content: jsonEncode(
            richContentTextEditingController.document.toDelta().toJson()),
      );
    }
  }
}
