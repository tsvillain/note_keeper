import 'package:equatable/equatable.dart';

class AppError extends Equatable {
  final String message;
  late final int timestamp;

  AppError({required this.message}) {
    timestamp = DateTime.now().microsecondsSinceEpoch;
  }

  @override
  List<Object?> get props => [message, timestamp];
}
