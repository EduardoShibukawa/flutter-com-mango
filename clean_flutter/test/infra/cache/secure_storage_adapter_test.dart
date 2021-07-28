import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:clean_flutter/infra/cache/cache.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  late SecureStorageAdapter sut;
  late FlutterSecureStorage secureStorage;
  late String key;
  late String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = SecureStorageAdapter(secureStorage: secureStorage);

    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  group('Save Secure', () {
    When mockFlutterSecureStorageCall() => when(() => secureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ));

    void mockFlutterSecureStorage() =>
        mockFlutterSecureStorageCall().thenAnswer((_) => Future.value());

    void mockFlutterSecureStorageError() =>
        mockFlutterSecureStorageCall().thenThrow(Exception());
    setUp(() {
      mockFlutterSecureStorage();
    });

    test('Should call save secure with correct values', () async {
      await sut.save(key: key, value: value);

      verify(() => secureStorage.write(key: key, value: value));
    });

    test('Should throw if save secure throws', () async {
      mockFlutterSecureStorageError();

      final future = sut.save(key: key, value: value);

      expect(future, throwsException);
    });
  });
  group('Fetch Secure', () {
    When mockFlutterSecureStorageCall() =>
        when(() => secureStorage.read(key: any(named: 'key')));

    void mockFlutterSecureStorage() =>
        mockFlutterSecureStorageCall().thenAnswer((_) => Future.value(value));

    void mockFlutterSecureStorageError() =>
        mockFlutterSecureStorageCall().thenThrow(Exception());

    setUp(() {
      mockFlutterSecureStorage();
    });
    test('Should call fetch secure with correct values', () async {
      await sut.fetch(key);

      verify(() => secureStorage.read(key: key));
    });

    test('Should return correct value on success', () async {
      final fetchedValue = await sut.fetch(key);

      expect(fetchedValue, value);
    });

    test('Should throw if FetchSecure throws', () async {
      mockFlutterSecureStorageError();

      final future = sut.fetch(key);

      expect(future, throwsException);
    });
  });

  group('Delete', () {
    When mockFlutterSecureStorageCall() => when(() => secureStorage.delete(
          key: any(named: 'key'),
        ));

    void mockFlutterSecureStorage() =>
        mockFlutterSecureStorageCall().thenAnswer((_) => Future.value());

    void mockFlutterSecureStorageError() =>
        mockFlutterSecureStorageCall().thenThrow(Exception());

    setUp(() {
      mockFlutterSecureStorage();
    });

    test('Should be called with correct key', () async {
      await sut.delete(key);

      verify(() => secureStorage.delete(key: key)).called(1);
    });

    test('Should throw if delete throws', () async {
      mockFlutterSecureStorageError();

      final future = sut.delete(key);

      expect(future, throwsException);
    });
  });
}
