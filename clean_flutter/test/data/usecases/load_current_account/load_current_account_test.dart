import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/domain/entities/entities.dart';
import 'package:clean_flutter/domain/usecases/load_current_account.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  late LocalLoadCurrentAccount sut;
  late FetchSecureCacheStorage fetchSecureCacheStorage;
  late String token;

  When mockFetchSecureCacheStorageCall() =>
      when(() => fetchSecureCacheStorage.fetchSecure(any()));

  void mockFetchSecureCacheStorage() =>
      mockFetchSecureCacheStorageCall().thenAnswer((_) => Future.value(token));

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(
        fetchSecureCacheStorage: fetchSecureCacheStorage);
    token = faker.guid.guid();

    mockFetchSecureCacheStorage();
  });
  test('Should call FetchSecureCacheStorage with correct values', () async {
    await sut.load();

    verify(() => fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });

  test('Should return an AccountEntity', () async {
    final account = await sut.load();

    expect(account.token, token);
  });
}

abstract class FetchSecureCacheStorage {
  Future<String> fetchSecure(String key);
}

class LocalLoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({required this.fetchSecureCacheStorage});

  Future<AccountEntity> load() async {
    final token = await fetchSecureCacheStorage.fetchSecure('token');
    return AccountEntity(token);
  }
}
