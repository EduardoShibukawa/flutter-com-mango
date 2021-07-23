import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage {}

void main() {
  late FetchCacheStorage fetchCacheStorage;
  late LocalLoadSurveys sut;

  setUp(() {
    fetchCacheStorage = FetchCacheStorageSpy();
    sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorage);

    when(() => fetchCacheStorage.fetch('surveys')).thenAnswer((_) async => {});
  });
  test('Should call FectchCacheStorage with correct key', () async {
    await sut.load();

    verify(() => fetchCacheStorage.fetch('surveys')).called(1);
  });
}

abstract class FetchCacheStorage {
  Future<void> fetch(String key);
}

class LocalLoadSurveys {
  final FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({required this.fetchCacheStorage});

  Future<void> load() async {
    fetchCacheStorage.fetch('surveys');
  }
}
