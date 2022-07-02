import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/provider.dart';
import 'package:note_keeper/core/state/state.dart';
import 'package:note_keeper/data/models/app_error.dart';
import 'package:note_keeper/data/repositories/respositories.dart';
import 'package:note_keeper/presentation/base_view_model.dart';

final _loginViewModel = ChangeNotifierProvider((ref) => LoginViewModel(
    ref.read(Repository.auth), ref.read(AppState.auth.notifier)));

mixin LoginView {
  //TODO:[tekeshwar] Add global snackbar to show this type of message / error
  void showError(AppError error);
}

class LoginViewModel extends BaseViewModel<LoginView> {
  final AuthRepository _auth;
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

      final user = await _auth.get();
      _authService.setUser(user);
    } on RepositoryException catch (e) {
      view!.showError(AppError(message: e.message));
    } finally {
      toggleLoadingOn(false);
    }
  }
}
