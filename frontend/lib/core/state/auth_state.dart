import 'package:appwrite/models.dart' as awm show Account;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/provider.dart';
import 'package:note_keeper/core/state/state.dart';
import 'package:note_keeper/data/models/models.dart';
import 'package:note_keeper/data/repositories/respositories_impl.dart';

final _authServiceProvider = StateNotifierProvider<AuthService, AuthState>(
    (ref) => AuthService(ref.read(Repository.auth), ref));

class AuthService extends StateNotifier<AuthState> {
  final AuthRepositoryImpl _authRepository;
  final Ref ref;

  static StateNotifierProvider<AuthService, AuthState> get provider =>
      _authServiceProvider;

  AuthService(this._authRepository, this.ref)
      //this had true on loading
      : super(const AuthState.unauthenticated(isLoading: false)) {
    // refresh was enable
    // state = state.copyWith(isLoading: true);
    // if (state.isAuthenticated) {
    refresh();
    // }
  }

  Future<void> refresh() async {
    // from master repo
    try {
      final user = await ref.read(BackendDependency.account).get();
      setUser(user);
      state.copyWith(isLoading: false);
    } on RepositoryException catch (_) {
      // logger.info('Not authenticated');
      state = const AuthState.unauthenticated();
    }
    //
    /*  try {

      late dynamic user;
      //?fixed this throws
      // user = await _authRepository.getAccount();
      user = await ref.read(BackendDependency.account).get();
      if (user != null) {
        setUser(user);
      }
    } on RepositoryException catch (_) {
      // logger.info('Not authenticated');
      state = const AuthState.unauthenticated();
    } */
  }

  void setUser(awm.Account user) {
    print(user.name);
    // logger.info('Authentication successful, setting $user');
    state = state.copyWith(user: user, isLoading: false);
  }

  Future<void> signOut() async {
    try {
      await _authRepository.deleteSession(sessionId: 'current');
      // logger.info('Sign out successful');
      state = const AuthState.unauthenticated();
    } on RepositoryException catch (e) {
      state = state.copyWith(error: AppError(message: e.message));
    }
  }
}

class AuthState extends StateBase {
  final awm.Account? user;
  final bool isLoading;

  const AuthState({
    this.user,
    this.isLoading = false,
    AppError? error,
  }) : super(error: error);

  const AuthState.unauthenticated({this.isLoading = false})
      : user = null,
        super(error: null);

  bool get isAuthenticated => user != null;

  @override
  List<Object?> get props => [user, isLoading, error];

  AuthState copyWith({
    awm.Account? user,
    bool? isLoading,
    AppError? error,
  }) =>
      AuthState(
        user: user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );
}
