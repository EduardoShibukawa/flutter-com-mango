import 'package:flutter/widgets.dart';

import 'strings/strings.dart';

class R {
  static Locale locale = Locale('pt', 'BR');
  static Translation strings = PtBr();

  static void load(Locale locale) {
    switch (locale.toString()) {
      default:
        locale = locale;
        strings = PtBr();
        break;
    }
  }
}
