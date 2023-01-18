import 'package:appwrite/models.dart';
import 'package:appwrite/appwrite.dart' as aw;

abstract class AuthRepository {
  Future<aw.Account> create({
    required String userId,
    required String email,
    required String password,
    required String name,
  });
  Future<Session> createSession({
    required String email,
    required String password,
  });

  Future<void> deleteSession({required String sessionId});

  Future<Account> get();
}
