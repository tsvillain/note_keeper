import 'package:appwrite/models.dart' as awm show Account;
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

      // from master repo
      await _auth.createSession(
          email: emailContoller.text, password: passwordContoller.text);
      late final awm.Account user;
      await _auth.getAccount().then((value) => user = value);
      _authService.setUser(user);
      _authService.refresh();
      //
      /*   await _auth
          .createSession(
              email: emailContoller.text, password: passwordContoller.text)
          .then((value) async {
        late final awm.Account user;

        _auth.getAccount().then((value) => user = value as awm.Account);

        // _authService.setUser(user);
        _authService.state.copyWith(user: user, isLoading: false);
      });
 */
      // await _auth.getAccount().then((value) => _authService.setUser(value));
    } on RepositoryException catch (e) {
      Messenger.showSnackbar(e.message);
    } finally {
      toggleLoadingOn(false);
    }
  }
}
