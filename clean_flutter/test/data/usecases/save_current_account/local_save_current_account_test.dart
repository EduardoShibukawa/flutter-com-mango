import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/domain/entities/entities.dart';
import 'package:clean_flutter/domain/helpers/helpers.dart';
import 'package:clean_flutter/data/usecase/usecase.dart';
import 'package:clean_flutter/data/cache/cache.dart';

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {
}

void main() {
  late LocalSaveCurrentAccount sut;
  late SaveSecureCacheStorage saveSecureCacheStorage;
  late AccountEntity account;

  When mockSaveSecureCacheStorageCall() =>
      when(() => saveSecureCacheStorage.save(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ));

  void mockSaveSecureCacheStorage() =>
      mockSaveSecureCacheStorageCall().thenAnswer((_) => Future.value());

  void mockSaveSecureCacheStorageError() =>
      mockSaveSecureCacheStorageCall().thenThrow(Exception());

  setUp(() {
    saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    sut =
        LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    account = AccountEntity(faker.guid.guid());

    mockSaveSecureCacheStorage();
  });

  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);

    verify(
        () => saveSecureCacheStorage.save(key: 'token', value: account.token));
  });

  test('Should throw UnexpectedError if SaveSecureCacheStorage throws',
      () async {
    mockSaveSecureCacheStorageError();

    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
