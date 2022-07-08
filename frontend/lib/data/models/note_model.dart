import 'package:note_keeper/core/enum/enum.dart';
import 'package:note_keeper/domain/entities/entities.dart';

class NoteModel extends Note {
  const NoteModel({
    required String owner,
    required PriorityEnum priority,
    required String content,
    required String title,
    required int createdAt,
    required int modifiedAt,
    String? docId,
  }) : super(
          content: content,
          createdAt: createdAt,
          modifiedAt: modifiedAt,
          owner: owner,
          priority: priority,
          title: title,
          docId: docId,
        );

  factory NoteModel.fromJson(Map<String, dynamic> map) => NoteModel(
        docId: map['\$id'],
        owner: map['owner'],
        priority: PriorityEnum.getPriorityEnumFromString(map['priority']),
        content: map['content'],
        title: map['title'],
        createdAt: map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
        modifiedAt: map['modifiedAt'] ?? DateTime.now().millisecondsSinceEpoch,
      );

  Map<String, dynamic> toJson() => {
        "owner": owner,
        "priority": priority.value,
        "content": content,
        "title": title,
        "createdAt": createdAt,
        "modifiedAt": DateTime.now().millisecondsSinceEpoch,
      };

  Map<String, dynamic> toJsonPatch() => {
        "priority": priority.value,
        "content": content,
        "title": title,
        "modifiedAt": DateTime.now().millisecondsSinceEpoch,
      };
}
