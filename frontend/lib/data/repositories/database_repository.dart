import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/provider.dart';
import 'package:note_keeper/data/repositories/respositories.dart';

final _databaseRepositoryProvider = Provider<DatabaseRepository>(
    (ref) => DatabaseRepository(ref.read(BackendDependency.database)));

class DatabaseRepository with RepositoryExceptionMixin {
  DatabaseRepository(this._database);

  static Provider<DatabaseRepository> get provider =>
      _databaseRepositoryProvider;

  final Database _database;

  Future<void> createNote() async {}
}
