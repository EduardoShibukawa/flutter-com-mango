import 'package:clean_flutter/ui/components/components.dart';
import 'package:flutter/material.dart';

mixin LoadingManager {
  void handleLoading(BuildContext context, Stream<bool> stream) {
    stream.listen((isLoading) {
      isLoading ? showLoading(context) : hideLoading(context);
    });
  }
}
