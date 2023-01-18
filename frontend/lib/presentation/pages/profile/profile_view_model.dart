import 'package:appwrite/models.dart' as awm;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/core/provider.dart';
import 'package:note_keeper/core/state/auth_state.dart';
import 'package:note_keeper/presentation/base_view_model.dart';

mixin ProfileView {}

final _userDetailsProvider =
    Provider<awm.Account>((ref) => ref.watch(AppState.auth).user!);

class ProfileViewModel extends BaseViewModel<ProfileView> {
  ProfileViewModel(this._authService);

  static AutoDisposeChangeNotifierProvider<ProfileViewModel> get provider =>
      ChangeNotifierProvider.autoDispose(
          (ref) => ProfileViewModel(ref.read(AppState.auth.notifier)));

  final AuthService _authService;

  Future<void> logout() async {
    await _authService.signOut();
  }
}
