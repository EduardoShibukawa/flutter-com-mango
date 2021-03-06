import 'package:get/get.dart';

mixin LoadingManager on GetxController {
  final _isLoading = false.obs;

  Stream<bool> get isLoadingStream => _isLoading.stream.map((s) => s!);

  set isLoading(bool value) => _isLoading.value = value;
}
