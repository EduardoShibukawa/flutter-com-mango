import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/data/cache/cache.dart';
import 'package:clean_flutter/data/usecase/usecase.dart';
import 'package:clean_flutter/domain/helpers/helpers.dart';

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

  void mockFetchSecureCacheStorageError() =>
      mockFetchSecureCacheStorageCall().thenThrow(Exception());

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

  test('Should throws UnexpectedError if FetchSecureCacheStorage throws',
      () async {
    mockFetchSecureCacheStorageError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
