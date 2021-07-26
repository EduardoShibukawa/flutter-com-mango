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
  setUp(() {
    localStorage = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorage);
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);

    when(() => localStorage.setItem(key, value)).thenAnswer((_) async => {});
  });

  test('Should call localStorage with correct values', () async {
    await sut.save(key: key, value: value);

    verify(() => localStorage.setItem(key, value)).called(1);
  });
}

class LocalStorageAdapter {
  final LocalStorage localStorage;

  LocalStorageAdapter({required this.localStorage});

  Future<void> save({required String key, required dynamic value}) async {
    await localStorage.setItem(key, value);
  }
}
