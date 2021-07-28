import 'package:clean_flutter/ui/components/components.dart';
import 'package:clean_flutter/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

mixin UIErrorManager {
  void handleMainError(BuildContext context, Stream<UIError?> stream) {
    stream.listen((error) {
      showErrorMessage(context, error!.description);
    });
  }
}
