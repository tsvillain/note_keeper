import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
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
      createdAt: DateTime.now().millisecondsSinceEpoch,
      modifiedAt: DateTime.now().millisecondsSinceEpoch,
    )));
  }

  Future<void> updateNote({
    required String title,
    required String content,
    required String docId,
    PriorityEnum priority = PriorityEnum.low,
  }) async {
    return exceptionHandler(_updateDocument(
      note: NoteModel(
        owner: _authState.user!.$id,
        priority: priority,
        content: content,
        title: title,
        createdAt: DateTime.now()
            .millisecondsSinceEpoch, // Any thing can be shared here
        modifiedAt: DateTime.now()
            .millisecondsSinceEpoch, // Any thing can be shared here
      ),
      noteID: docId,
    ));
  }

  Future<NoteModel> getNoteByID({required String noteID}) async {
    return exceptionHandler(_getNoteById(noteID: noteID));
  }

  Future<List<NoteModel>> getNotesOfUser() async {
    return exceptionHandler(_getAllNotesOfUser());
  }

  //

  Future<void> _createDocument({required NoteModel note}) async {
    await _database.createDocument(
      collectionId: CollectionNames.note,
      documentId: 'unique()',
      data: note.toJson(),
    );
  }

  Future<void> _updateDocument(
      {required NoteModel note, required String noteID}) async {
    await _database.updateDocument(
      collectionId: CollectionNames.note,
      documentId: noteID,
      data: note.toJsonPatch(),
    );
  }

  Future<NoteModel> _getNoteById({required String noteID}) async {
    final Document doc = await _database.getDocument(
      collectionId: CollectionNames.note,
      documentId: noteID,
    );
    logger.info(doc.data);
    return NoteModel.fromJson(doc.data);
  }

  Future<List<NoteModel>> _getAllNotesOfUser() async {
    final DocumentList docs = await _database.listDocuments(
      collectionId: CollectionNames.note,
      queries: [Query.equal('owner', _authState.user!.$id)],
    );
    return docs.documents.map((e) => NoteModel.fromJson(e.data)).toList();
  }
}
