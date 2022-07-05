import 'package:equatable/equatable.dart';
import 'package:note_keeper/core/enum/enum.dart';

class NoteModel extends Equatable {
  final String owner;
  final PriorityEnum priority;
  final String content;
  final String title;
  final int createdAt;
  final int modifiedAt;
  final String? docId;

  const NoteModel({
    this.docId,
    required this.owner,
    required this.priority,
    required this.content,
    required this.title,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> map, String docId) =>
      NoteModel(
        docId: docId,
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

  @override
  List<Object?> get props =>
      [owner, priority, content, title, createdAt, modifiedAt];
}
