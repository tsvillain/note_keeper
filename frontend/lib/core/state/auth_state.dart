import 'package:appwrite/models.dart';
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
      : super(const AuthState.unauthenticated(isLoading: true)) {
    refresh();
    state = state.copyWith(isLoading: false);
  }

  Future<void> refresh() async {
    try {
      final user = await _authRepository.get();
      setUser(user);
    } on RepositoryException catch (_) {
      // logger.info('Not authenticated');
      state = state.copyWith(user: null, isLoading: false);
    }
  }

  void setUser(Account user) {
    state = state.copyWith(isLoading: false, user: user);
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
  final Account? user;
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
    Account? user,
    bool? isLoading,
    AppError? error,
  }) =>
      AuthState(
        user: user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );
}
