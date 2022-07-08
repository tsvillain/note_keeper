import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/provider.dart';
import 'package:note_keeper/data/repositories/respositories_impl.dart';
import 'package:note_keeper/domain/repositories/repositories.dart';

final _authRepositoryProvider = Provider<AuthRepositoryImpl>(
    (ref) => AuthRepositoryImpl(ref.read(BackendDependency.account)));

class AuthRepositoryImpl extends AuthRepository with RepositoryExceptionMixin {
  static Provider<AuthRepositoryImpl> get provider => _authRepositoryProvider;

  final Account _account;

  AuthRepositoryImpl(this._account);

  @override
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

  @override
  Future<Session> createSession(
      {required String email, required String password}) {
    return exceptionHandler(
        _account.createSession(email: email, password: password));
  }

  @override
  Future<void> deleteSession({required String sessionId}) {
    return exceptionHandler(_account.deleteSession(sessionId: sessionId));
  }

  @override
  Future<User> get() {
    return exceptionHandler(_account.get());
  }
}
