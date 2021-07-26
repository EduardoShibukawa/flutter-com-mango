import 'package:faker/faker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/infra/cache/cache.dart';

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  late LocalStorageSpy localStorage;
  late LocalStorageAdapter sut;
  late String key;
  late dynamic value;

  When mockDeleteCall() => when(() => localStorage.deleteItem(key));

  void mockDelete() => mockDeleteCall().thenAnswer((_) async => {});

  void mockDeleteError() => mockDeleteCall().thenThrow(Exception());

  When mockSetCall() => when(() => localStorage.setItem(key, value));

  void mockSet() => mockSetCall().thenAnswer((_) async => {});

  void mockSetError() => mockSetCall().thenThrow(Exception());

  setUp(() {
    localStorage = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorage);
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);

    mockDelete();
    mockSet();
  });

  group('Save', () {
    test('Should call localStorage with correct values', () async {
      await sut.save(key: key, value: value);

      verify(() => localStorage.deleteItem(key)).called(1);
      verify(() => localStorage.setItem(key, value)).called(1);
    });

    test('Should throw if deleteItem throws', () async {
      mockDeleteError();

      final future = sut.save(key: key, value: value);

      expect(future, throwsException);
    });

    test('Should throw if setItem throws', () async {
      mockSetError();

      final future = sut.save(key: key, value: value);

      expect(future, throwsException);
    });
  });

  group('Delete', () {
    test('Should call localStorage with correct values', () async {
      await sut.delete(key);

      verify(() => localStorage.deleteItem(key)).called(1);
    });

    test('Should throw if deleteItem throws', () async {
      mockDeleteError();

      final future = sut.delete(key);

      expect(future, throwsException);
    });
  });
}
