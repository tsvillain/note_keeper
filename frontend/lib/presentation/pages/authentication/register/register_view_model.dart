import 'package:flutter/material.dart';
import 'package:appwrite/models.dart' as awm show Account;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/provider.dart';
import 'package:note_keeper/core/state/state.dart';
import 'package:note_keeper/data/models/app_error.dart';
import 'package:note_keeper/data/repositories/respositories_impl.dart';
import 'package:note_keeper/presentation/base_view_model.dart';

final _registerViewModel = ChangeNotifierProvider((ref) => RegisterViewModel(
    ref.read(Repository.auth), ref.read(AppState.auth.notifier)));

mixin RegisterView {
  void showError(AppError error);
}

class RegisterViewModel extends BaseViewModel<RegisterView> {
  final AuthRepositoryImpl _auth;
  final AuthService _authService;

  static ChangeNotifierProvider<RegisterViewModel> get provider =>
      _registerViewModel;

  final TextEditingController nameContoller = TextEditingController();
  final TextEditingController emailContoller = TextEditingController();
  final TextEditingController passwordContoller = TextEditingController();

  RegisterViewModel(this._auth, this._authService);

  @override
  void dispose() {
    nameContoller.dispose();
    emailContoller.dispose();
    passwordContoller.dispose();
    super.dispose();
  }

  Future<void> createUser() async {
    try {
      toggleLoadingOn(true);
      await _auth.exceptionHandler(_auth.create(
        userId: 'unique()',
        email: emailContoller.text,
        password: passwordContoller.text,
        name: nameContoller.text,
      ));

      await _auth.createSession(
          email: emailContoller.text, password: passwordContoller.text);

      final user = await _auth.getAccount();
      _authService.setUser(user as awm.Account);
    } on RepositoryException catch (e) {
      view!.showError(AppError(message: e.message));
    } finally {
      toggleLoadingOn(false);
    }
  }
}
