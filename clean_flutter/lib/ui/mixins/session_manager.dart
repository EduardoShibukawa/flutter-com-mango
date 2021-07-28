import 'package:get/get.dart';

mixin SessionManager {
  void handleSessionExpired(Stream<bool> stream) {
    stream.listen((isSessionExpired) {
      if (isSessionExpired) {
        Get.offAllNamed('/login');
      }
    });
  }
}
