import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  test('Should call FetchSecureCacheStorage with correct values', () async {
    final fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    final sut = LocalLoadCurrentAccount(
        fetchSecureCacheStorage: fetchSecureCacheStorage);

    when(() => fetchSecureCacheStorage.fetchSecure(any()))
        .thenAnswer((_) => Future.value());

    await sut.load();

    verify(() => fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });
}

abstract class FetchSecureCacheStorage {
  Future<void> fetchSecure(String key);
}

class LocalLoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({required this.fetchSecureCacheStorage});

  Future<void> load() async {
    await fetchSecureCacheStorage.fetchSecure('token');
  }
}
