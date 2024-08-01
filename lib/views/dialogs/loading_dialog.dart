import 'package:apos_app/main.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LoadingDialog {
  static void show() {
    if (navigatorKey.currentState?.context != null) {
      navigatorKey.currentState!.context.loaderOverlay.show();
    }
  }

  static void hide() {
    if (navigatorKey.currentState?.context != null) {
      navigatorKey.currentState!.context.loaderOverlay.hide();
    }
  }
}
