import 'package:clean_flutter/domain/entities/entities.dart';
import 'package:clean_flutter/domain/usecases/load_current_account.dart';
import 'package:clean_flutter/ui/pages/pages.dart';
import 'package:get/state_manager.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  late LoadCurrentAccount loadCurrentAccount;
  late GetxSplashPresenter sut;

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);

    when(() => loadCurrentAccount.load())
        .thenAnswer((invocation) => Future.value(AccountEntity('token')));
  });

  test('Should call LoadCurrentAccount', () async {
    await sut.checkAccount();

    verify(() => loadCurrentAccount.load()).called(1);
  });
}

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;
  final _navigateTo = RxnString();

  GetxSplashPresenter({required this.loadCurrentAccount});

  Stream<String> get navigateToStream => _navigateTo.stream.map((e) => e!);

  Future<void> checkAccount() async {
    await loadCurrentAccount.load();
  }
}
