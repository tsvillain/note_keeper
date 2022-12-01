import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/state/state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:note_keeper/data/repositories/respositories_impl.dart';

abstract class BackendDependency {
  static Provider<Client> get client => _clientProvider;
  static Provider<Databases> get database => _databaseProvider;
  static Provider<Account> get account => _accountProvider;
}

abstract class Repository {
  static Provider<AuthRepositoryImpl> get auth => AuthRepositoryImpl.provider;
  static Provider<DatabaseRepositoryImpl> get database =>
      DatabaseRepositoryImpl.provider;
}

abstract class AppState {
  static StateNotifierProvider<AuthService, AuthState> get auth =>
      AuthService.provider;
}

final _clientProvider = Provider<Client>(
  (ref) => Client()
    ..setProject(dotenv.env['APPWRITE_PROJECT_ID'])
    ..setEndpoint(dotenv.env['APPWRITE_ENDPOINT'] ?? "http://localhost/v1"),
);

final _databaseProvider =
    Provider<Databases>((ref) => Databases(ref.read(_clientProvider)));

final _accountProvider =
    Provider<Account>((ref) => Account(ref.read(_clientProvider)));
