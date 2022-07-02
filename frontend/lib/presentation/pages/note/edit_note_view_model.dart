import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/provider.dart';
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
  final TextEditingController contentTextEditingController =
      TextEditingController();
  final QuillController richContentTextEditingController =
      QuillController.basic();

  bool isNewNote = false;

  @override
  void dispose() {
    titleTextEditingController.dispose();
    contentTextEditingController.dispose();
    richContentTextEditingController.dispose();
    super.dispose();
  }

  Future<void> initAfterLoad({String? noteID}) async {
    try {
      toggleLoadingOn(true);
      if (noteID != null) {
        isNewNote = false;
        //TODO:[tekeshwar] getNoteDetails!

      } else {
        isNewNote = true;
      }
    } catch (_) {
    } finally {
      toggleLoadingOn(false);
    }
  }

  Future<void> saveNote() async {
    if (isNewNote) {
      await _databaseRepository.createNote(
        title: titleTextEditingController.text,
        content: jsonEncode(
            richContentTextEditingController.document.toDelta().toJson()),
      );
    }
  }
}
