import 'package:note_keeper/core/enum/enum.dart';
import 'package:note_keeper/data/models/models.dart';

abstract class DatabaseRepository {
  Future<void> createNote({
    required String title,
    required String content,
    PriorityEnum priority = PriorityEnum.low,
  });
  Future<void> updateNote({
    required String title,
    required String content,
    required String docId,
    PriorityEnum priority = PriorityEnum.low,
  });
  Future<NoteModel> getNoteByID({required String noteID});
  Future<bool> deleteNoteByID({required String noteID});
  Future<List<NoteModel>> getNotesOfUser();
}
