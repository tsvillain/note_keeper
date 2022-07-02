import 'package:flutter/foundation.dart';

abstract class BaseViewModel<T> extends ChangeNotifier {
  late T? view;
  bool isLoading = false;

  void toggleLoadingOn(bool on) {
    isLoading = on;
    notifyListeners();
  }

  void attachView(T view) {
    this.view = view;
  }

  void detachView() {
    view = null;
  }

  @override
  void dispose() {
    detachView();
    super.dispose();
  }
}
