import 'package:faker/faker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  late LocalStorageSpy localStorage;
  late LocalStorageAdapter sut;
  late String key;
  late dynamic value;

  When mockDeleteItemCall() => when(() => localStorage.deleteItem(key));

  void mockDeleteItem() => mockDeleteItemCall().thenAnswer((_) async => {});

  void mockDeleteItemError() => mockDeleteItemCall().thenThrow(Exception());

  When mockSetItemCall() => when(() => localStorage.setItem(key, value));

  void mockSetItem() => mockSetItemCall().thenAnswer((_) async => {});

  void mockSetItemError() => mockSetItemCall().thenThrow(Exception());

  setUp(() {
    localStorage = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorage);
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);

    mockDeleteItem();
    mockSetItem();
  });

  test('Should call localStorage with correct values', () async {
    await sut.save(key: key, value: value);

    verify(() => localStorage.deleteItem(key)).called(1);
    verify(() => localStorage.setItem(key, value)).called(1);
  });

  test('Should throw if deleteItem throws', () async {
    mockDeleteItemError();

    final future = sut.save(key: key, value: value);

    expect(future, throwsException);
  });

  test('Should throw if setItem throws', () async {
    mockSetItemError();

    final future = sut.save(key: key, value: value);

    expect(future, throwsException);
  });
}

class LocalStorageAdapter {
  final LocalStorage localStorage;

  LocalStorageAdapter({required this.localStorage});

  Future<void> save({required String key, required dynamic value}) async {
    await localStorage.deleteItem(key);
    await localStorage.setItem(key, value);
  }
}
