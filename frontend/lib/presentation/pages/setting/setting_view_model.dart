import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/provider.dart';
import 'package:note_keeper/core/state/state.dart';
import 'package:note_keeper/presentation/base_view_model.dart';

mixin SettingView {}

class SettingViewModel extends BaseViewModel<SettingView> {
  SettingViewModel(this._authService);

  static AutoDisposeChangeNotifierProvider<SettingViewModel> get provider =>
      ChangeNotifierProvider.autoDispose(
          (ref) => SettingViewModel(ref.read(AppState.auth.notifier)));

  final AuthService _authService;

  Future<void> logout() async {
    await _authService.signOut();
  }
}
