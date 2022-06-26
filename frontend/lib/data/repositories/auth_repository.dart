import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/provider.dart';
import 'package:note_keeper/data/repositories/respositories.dart';

final _authRepositoryProvider = Provider<AuthRepository>(
    (ref) => AuthRepository(ref.read(BackendDependency.account)));

class AuthRepository with RepositoryExceptionMixin {
  static Provider<AuthRepository> get provider => _authRepositoryProvider;

  final Account _account;

  AuthRepository(this._account);

  Future<User> create({
    required String email,
    required String password,
    required String name,
  }) {
    return exceptionHandler(_account.create(
      userId: 'unique()',
      email: email,
      password: password,
      name: name,
    ));
  }

  Future<Session> createSession(
      {required String email, required String password}) {
    return exceptionHandler(
        _account.createSession(email: email, password: password));
  }

  Future<void> deleteSession({required String sessionId}) {
    return exceptionHandler(_account.deleteSession(sessionId: sessionId));
  }

  Future<User> get() {
    return exceptionHandler(_account.get());
  }
}
