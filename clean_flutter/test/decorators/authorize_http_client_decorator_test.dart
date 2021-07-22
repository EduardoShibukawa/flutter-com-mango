import 'package:clean_flutter/data/cache/fetch_secure_cache_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  late FetchSecureCacheStorage fetchSecureCacheStorage;
  late AuthorizeHttpClientDecorator sut;

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = AuthorizeHttpClientDecorator(
        fetchSecureCacheStorage: fetchSecureCacheStorage);

    when(() => fetchSecureCacheStorage.fetchSecure(any()))
        .thenAnswer((_) async => 'token');
  });

  test('Should call FetchSecureCacheStorage with correct key', () async {
    await sut.request();

    verify(() => fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });
}

class AuthorizeHttpClientDecorator {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  AuthorizeHttpClientDecorator({required this.fetchSecureCacheStorage});

  Future<void> request() async {
    await fetchSecureCacheStorage.fetchSecure('token');
  }
}
