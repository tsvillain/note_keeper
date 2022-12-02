import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/provider.dart';
import 'package:note_keeper/core/state/state.dart';
import 'package:note_keeper/core/utils/messenger.dart';
import 'package:note_keeper/data/repositories/respositories_impl.dart';
import 'package:note_keeper/presentation/base_view_model.dart';

final _loginViewModel = ChangeNotifierProvider((ref) => LoginViewModel(
    ref.read(Repository.auth), ref.read(AppState.auth.notifier)));
final _authRepositoryProvider =
    Provider<AuthRepositoryImpl>((ref) => AuthRepositoryImpl(
          ref.read(BackendDependency.account),
        ));

mixin LoginView {}

class LoginViewModel extends BaseViewModel<LoginView> {
  final AuthRepositoryImpl _auth;
  final AuthService _authService;

  static ChangeNotifierProvider<LoginViewModel> get provider => _loginViewModel;

  final TextEditingController emailContoller = TextEditingController();
  final TextEditingController passwordContoller = TextEditingController();

  LoginViewModel(this._auth, this._authService);

  @override
  void dispose() {
    emailContoller.dispose();
    passwordContoller.dispose();
    super.dispose();
  }

  Future<void> createSession() async {
    try {
      toggleLoadingOn(true);

      await _auth.createSession(
          email: emailContoller.text, password: passwordContoller.text);

      await _authService.refresh();
      toggleLoadingOn(false);
    } on RepositoryException catch (e) {
      Messenger.showSnackbar(e.message);
    } finally {
      toggleLoadingOn(false);
    }
  }
}
