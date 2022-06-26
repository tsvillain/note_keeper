import 'package:equatable/equatable.dart';
import 'package:note_keeper/core/enum/enum.dart';

class NoteModel extends Equatable {
  final String owner;
  final PriorityEnum priority;
  final String content;
  final String title;

  const NoteModel({
    required this.owner,
    required this.priority,
    required this.content,
    required this.title,
  });

  factory NoteModel.fromJson(Map<String, dynamic> map) => NoteModel(
        owner: map['owner'],
        priority: PriorityEnum.getPriorityEnumFromString(map['priority']),
        content: map['content'],
        title: map['title'],
      );

  Map<String, dynamic> toJson() => {
        "owner": owner,
        "priority": priority.value,
        "content": content,
        "title": title,
      };

  @override
  List<Object?> get props => [owner, priority, content, title];
}
