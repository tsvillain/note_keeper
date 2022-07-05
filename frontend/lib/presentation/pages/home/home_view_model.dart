import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/provider.dart';
import 'package:note_keeper/data/models/models.dart';
import 'package:note_keeper/data/repositories/respositories.dart';
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

  final DatabaseRepository _databaseRepository;

  final notesListScrollController = ScrollController();
  bool showAppBar = true;

  List<NoteModel> _notes = [];

  List<NoteModel> get getNotes => _notes;

  void initialize() {
    notesListScrollController.addListener(() {
      if (notesListScrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (showAppBar != true) {
          showAppBar = true;
          notifyListeners();
        }
      } else if (notesListScrollController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          notesListScrollController.offset > kToolbarHeight) {
        if (showAppBar != false) {
          showAppBar = false;
          notifyListeners();
        }
      }
    });
  }

  void _fetchNotes() async {
    _notes = await _databaseRepository.getNotesOfUser();
    notifyListeners();
  }
}
