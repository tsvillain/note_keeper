import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_keeper/presentation/base_view_model.dart';

mixin SettingView {}

class SettingViewModel extends BaseViewModel<SettingView> {
  static AutoDisposeChangeNotifierProvider<SettingViewModel> get provider =>
      ChangeNotifierProvider.autoDispose((ref) => SettingViewModel());
}
