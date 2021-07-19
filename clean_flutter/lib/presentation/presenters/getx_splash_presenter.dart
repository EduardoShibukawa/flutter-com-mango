import 'package:clean_flutter/domain/usecases/usecases.dart';
import 'package:get/get.dart';

import '../../ui/pages/pages.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;
  final _navigateTo = RxnString();

  GetxSplashPresenter({required this.loadCurrentAccount});

  Stream<String> get navigateToStream => _navigateTo.stream.map((e) => e!);

  Future<void> checkAccount() async {
    try {
      final account = await loadCurrentAccount.load();
      _navigateTo.value =
          account?.token.isEmpty == null ? '/login' : '/surveys';
    } catch (_) {
      _navigateTo.value = '/login';
    }
  }
}
