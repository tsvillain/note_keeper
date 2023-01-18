import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/constant/constant.dart';
import 'package:note_keeper/core/enum/enum.dart';
import 'package:note_keeper/core/provider.dart';
import 'package:note_keeper/core/state/state.dart';
import 'package:note_keeper/data/models/models.dart';
import 'package:note_keeper/data/repositories/respositories_impl.dart';
import 'package:note_keeper/domain/repositories/repositories.dart';

final _databaseRepositoryProvider = Provider<DatabaseRepositoryImpl>((ref) =>
    DatabaseRepositoryImpl(
        ref.read(BackendDependency.database), ref.watch(AppState.auth)));

class DatabaseRepositoryImpl extends DatabaseRepository
    with RepositoryExceptionMixin {
  /// Private constructor

  //below is the working constructor. but needs to have user Id as field
  DatabaseRepositoryImpl(this._database, this._authState);
  String get userId => _authState.user!.$id;

  static Provider<DatabaseRepositoryImpl> get provider =>
      _databaseRepositoryProvider;
  final Databases _database;
  final AuthState _authState;

  final String databaseId = CollectionNames.databaseId;

  @override
  Future<void> createNote({
    required String title,
    required String content,
    PriorityEnum priority = PriorityEnum.low,
  }) async {
    // late final String myUserId;
    // await _authState.user.$id !.get().then((value) => myUserId = value.$id);

    return exceptionHandler(_createDocument(
        note: NoteModel(
      owner: userId,
      priority: priority,
      content: content,
      title: title,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      modifiedAt: DateTime.now().millisecondsSinceEpoch,
    )));
  }

  @override
  Future<void> updateNote({
    required String title,
    required String content,
    required String docId,
    PriorityEnum priority = PriorityEnum.low,
  }) async {
    return exceptionHandler(_updateDocument(
      note: NoteModel(
        owner: userId,
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

  @override
  Future<NoteModel> getNoteByID({required String noteID}) async {
    return exceptionHandler(_getNoteById(noteID: noteID));
  }

  @override
  Future<List<NoteModel>> getNotesOfUser() async {
    return exceptionHandler(_getAllNotesOfUser());
  }

  @override
  Future<bool> deleteNoteByID({required String noteID}) async {
    return exceptionHandler(_deleteNoteById(noteID: noteID));
  }

  //

  Future<void> _createDocument({required NoteModel note}) async {
    await _database.createDocument(
      databaseId: databaseId,
      collectionId: CollectionNames.note,
      documentId: ID.unique(),
      data: note.toJson(),
      permissions: [
        Permission.read(Role.users()),
        Permission.update(Role.user(userId)),
        Permission.delete(Role.user(userId)),
      ],
    );
  }

  Future<void> _updateDocument(
      {required NoteModel note, required String noteID}) async {
    await _database.updateDocument(
      databaseId: databaseId,
      collectionId: CollectionNames.note,
      documentId: noteID,
      data: note.toJsonPatch(),
      permissions: [
        Permission.read(Role.users()),
        Permission.update(Role.user(userId)),
      ],
    );
  }

  Future<bool> _deleteNoteById({required String noteID}) async {
    await _database.deleteDocument(
        databaseId: databaseId,
        collectionId: CollectionNames.note,
        documentId: noteID);
    return true;
  }

  Future<NoteModel> _getNoteById({required String noteID}) async {
    final Document doc = await _database.getDocument(
      databaseId: databaseId,
      collectionId: CollectionNames.note,
      documentId: noteID,
    );
    logger.info(doc.data);
    return NoteModel.fromJson(doc.data);
  }

  Future<List<NoteModel>> _getAllNotesOfUser() async {
    final DocumentList docs = await _database.listDocuments(
      databaseId: databaseId,
      collectionId: CollectionNames.note,
      queries: [Query.equal('owner', _authState.user!.$id)],
    );
    return docs.documents.map((e) => NoteModel.fromJson(e.data)).toList();
  }
}
