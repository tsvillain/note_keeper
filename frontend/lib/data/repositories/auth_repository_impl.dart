import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as awm show Session, Account;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/provider.dart';
import 'package:note_keeper/data/repositories/respositories_impl.dart';
import 'package:note_keeper/domain/repositories/repositories.dart';

final _authRepositoryProvider =
    Provider<AuthRepositoryImpl>((ref) => AuthRepositoryImpl(
          ref.read(BackendDependency.account),
        ));

class AuthRepositoryImpl extends AuthRepository with RepositoryExceptionMixin {
  static Provider<AuthRepositoryImpl> get provider => _authRepositoryProvider;

  final Account _account;
  awm.Session? _session;

  awm.Session get session => _session!;
  // final Databases _database;

  AuthRepositoryImpl(this._account);

  @override
  Future<awm.Session> createSession(
      {required String email, required String password}) {
    return exceptionHandler(
        _account.createEmailSession(email: email, password: password));
  }

  @override
  Future<void> deleteSession({required String sessionId}) {
    return exceptionHandler(_account.deleteSession(sessionId: sessionId));
  }

  @override
  Future<awm.Account> get() {
    return (exceptionHandler(_account.get()));
  }

  @override
  Future<Account> create(
      {required String email,
      required String password,
      required String name,
      required String userId}) {
    // TODO: implement create
    throw UnimplementedError();
  }
}
