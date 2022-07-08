import 'package:appwrite/models.dart';

abstract class AuthRepository {
  Future<User> create({
    required String email,
    required String password,
    required String name,
  });
  Future<Session> createSession({
    required String email,
    required String password,
  });

  Future<void> deleteSession({required String sessionId});

  Future<User> get();
}
