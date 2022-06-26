import 'dart:async';
import 'package:appwrite/appwrite.dart';
import 'package:logging/logging.dart';

class RepositoryException implements Exception {
  final String message;
  final Exception? exception;
  final StackTrace? stackTrace;

  const RepositoryException(
      {required this.message, this.exception, this.stackTrace});

  @override
  String toString() {
    return "RepositoryException: $message";
  }
}

mixin RepositoryExceptionMixin {
  final Logger logger = Logger("repo");
  Future<T> exceptionHandler<T>(FutureOr computation,
      {String unkownMessage = 'Repository Exception'}) async {
    try {
      return await computation;
    } on AppwriteException catch (e) {
      logger.warning(e.message);
      throw RepositoryException(message: e.message ?? 'Unknown error occured');
    } on Exception catch (e, st) {
      logger.severe(unkownMessage, e, st);
      throw RepositoryException(
          message: unkownMessage, exception: e, stackTrace: st);
    }
  }
}
