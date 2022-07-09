import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/provider.dart';
import 'package:note_keeper/core/utils/messenger.dart';
import 'package:note_keeper/data/models/models.dart';
import 'package:note_keeper/data/repositories/respositories_impl.dart';
import 'package:note_keeper/presentation/base_view_model.dart';

class HomeView {}

final _homeViewModel = ChangeNotifierProvider.autoDispose(
    (ref) => HomeViewModel(ref.read(Repository.database)));

class HomeViewModel extends BaseViewModel<HomeView> {
  HomeViewModel(this._databaseRepository) {
    _fetchNotes();
  }

  static AutoDisposeChangeNotifierProvider<HomeViewModel> get provider =>
      _homeViewModel;

  final DatabaseRepositoryImpl _databaseRepository;

  final notesListScrollController = ScrollController();

  bool crossAxisCountTwo = true;
  bool showDelete = false;

  List<NoteModel> _notes = [];

  List<NoteModel> get getNotes => _notes;

  void toggleCrossAxisCount() {
    crossAxisCountTwo = !crossAxisCountTwo;
    notifyListeners();
  }

  void toggleShowDelete({bool? v}) {
    showDelete = v ?? !showDelete;
    notifyListeners();
  }

  Future<void> _fetchNotes() async {
    _notes = await _databaseRepository.getNotesOfUser();
    notifyListeners();
  }

  void deleteNote(String noteId) async {
    try {
      toggleLoadingOn(true);
      await _databaseRepository.deleteNoteByID(noteID: noteId);
      Messenger.showSnackbar("✅ Note Deleted");
      await _fetchNotes();
    } catch (_) {
      Messenger.showSnackbar("🚨 Failed to Delete Note");
    } finally {
      toggleLoadingOn(false);
    }
  }
}
