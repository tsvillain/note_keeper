import 'package:equatable/equatable.dart';
import 'package:note_keeper/core/enum/enum.dart';

class Note extends Equatable {
  final String owner;
  final PriorityEnum priority;
  final String content;
  final String title;
  final int createdAt;
  final int modifiedAt;
  final String? docId;

  const Note({
    this.docId,
    required this.owner,
    required this.priority,
    required this.content,
    required this.title,
    required this.createdAt,
    required this.modifiedAt,
  });

  @override
  List<Object?> get props =>
      [owner, priority, content, title, createdAt, modifiedAt];
}
