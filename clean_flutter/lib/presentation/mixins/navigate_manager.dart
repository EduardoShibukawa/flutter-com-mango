import 'package:get/get.dart';

mixin NavigateManager {
  final _navigateTo = Rxn<String>();

  Stream<String> get navigateToStream => _navigateTo.stream.map((s) => s!);

  set navigateTo(String value) => _navigateTo.value = value;
}
