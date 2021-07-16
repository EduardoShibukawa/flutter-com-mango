import 'package:clean_flutter/data/cache/cache.dart';
import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  late LocalStorageAdapter sut;
  late FlutterSecureStorage secureStorage;
  late String key;
  late String value;

  When mockFlutterSecureStorageCall() => when(() => secureStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ));

  void mockFlutterSecureStorage() =>
      mockFlutterSecureStorageCall().thenAnswer((_) => Future.value());

  void mockFlutterSecureStorageError() =>
      mockFlutterSecureStorageCall().thenThrow(Exception());

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = LocalStorageAdapter(secureStorage: secureStorage);

    key = faker.lorem.word();
    value = faker.guid.guid();

    mockFlutterSecureStorage();
  });
  test('Should call save secure with correct values', () async {
    await sut.saveSecure(key: key, value: value);

    verify(() => secureStorage.write(key: key, value: value));
  });

  test('Should throw if save secure throws', () async {
    mockFlutterSecureStorageError();

    final future = sut.saveSecure(key: key, value: value);

    expect(future, throwsException);
  });
}

class LocalStorageAdapter implements SaveSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  LocalStorageAdapter({required this.secureStorage});

  Future<void> saveSecure({required String key, required String value}) async {
    await secureStorage.write(key: key, value: value);
  }
}
