import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/constant/constant.dart';
import 'package:note_keeper/core/enum/enum.dart';
import 'package:note_keeper/core/provider.dart';
import 'package:note_keeper/core/state/state.dart';
import 'package:note_keeper/data/models/models.dart';
import 'package:note_keeper/data/repositories/respositories.dart';

final _databaseRepositoryProvider = Provider<DatabaseRepository>((ref) =>
    DatabaseRepository(
        ref.read(BackendDependency.database), ref.watch(AppState.auth)));

class DatabaseRepository with RepositoryExceptionMixin {
  DatabaseRepository(this._database, this._authState);

  static Provider<DatabaseRepository> get provider =>
      _databaseRepositoryProvider;

  final Database _database;
  final AuthState _authState;

  Future<void> createNote({
    required String title,
    required String content,
    PriorityEnum priority = PriorityEnum.low,
  }) async {
    return exceptionHandler(_createDocument(
        note: NoteModel(
      owner: _authState.user!.$id,
      priority: priority,
      content: content,
      title: title,
    )));
  }

  Future<void> _createDocument({required NoteModel note}) async {
    await _database.createDocument(
      collectionId: CollectionNames.note,
      documentId: 'unique()',
      data: note.toJson(),
    );
  }
}
