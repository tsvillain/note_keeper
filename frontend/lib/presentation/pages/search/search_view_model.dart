import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/provider.dart';
import 'package:note_keeper/core/utils/messenger.dart';
import 'package:note_keeper/data/models/models.dart';
import 'package:note_keeper/data/repositories/respositories_impl.dart';
import 'package:note_keeper/presentation/base_view_model.dart';

class SearchView {}

final _searchViewModel = ChangeNotifierProvider.autoDispose(
    (ref) => SearchViewModel(ref.read(Repository.database)));

class SearchViewModel extends BaseViewModel<SearchView> {
  SearchViewModel(this._databaseRepository) {
    _fetchNotes();
  }

  static AutoDisposeChangeNotifierProvider<SearchViewModel> get provider =>
      _searchViewModel;

  final DatabaseRepositoryImpl _databaseRepository;

  bool crossAxisCountTwo = true;
  final notesListScrollController = ScrollController();

  List<NoteModel> _notes = [];
  List<NoteModel> _filteredNotes = [];

  List<NoteModel> get getNotes => _filteredNotes;

  final TextEditingController searchTextController = TextEditingController();

  Future<void> _fetchNotes() async {
    _notes = await _databaseRepository.getNotesOfUser();
    searchTextController.addListener(_filterNotes);
  }

  void _filterNotes() {
    if (searchTextController.text.isNotEmpty) {
      _filteredNotes = [
        ..._notes.where(
          (note) =>
              note.title
                  .toLowerCase()
                  .replaceAll("insert", "")
                  .replaceAll("\n", "")
                  .contains(searchTextController.text.trim().toLowerCase()) ||
              note.content
                  .toLowerCase()
                  .replaceAll("insert", "")
                  .replaceAll("\n", "")
                  .contains(searchTextController.text.trim().toLowerCase()),
        )
      ];
      notifyListeners();
    }
    if (_filteredNotes.isNotEmpty) {
      Messenger.showSnackbar(
          "${_filteredNotes.length} Note${_filteredNotes.length > 1 ? "s" : ""} Found");
    }
  }

  void toggleCrossAxisCount() {
    crossAxisCountTwo = !crossAxisCountTwo;
    notifyListeners();
  }
}
