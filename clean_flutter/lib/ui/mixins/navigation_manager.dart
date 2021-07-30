import 'package:get/get.dart';

mixin NavigationManager {
  void handleNavigation(Stream<String> stream, {bool clear = false}) {
    stream.listen((page) {
      if (page.isNotEmpty && Get.currentRoute != page) {
        if (clear) {
          Get.offAllNamed(page);
        } else {
          Get.toNamed(page);
        }
      }
    });
  }
}
