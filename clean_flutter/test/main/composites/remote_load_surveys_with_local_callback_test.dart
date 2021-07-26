import 'package:clean_flutter/data/usecase/usecase.dart';
import 'package:clean_flutter/domain/entities/survey_entity.dart';
import 'package:clean_flutter/domain/helpers/helpers.dart';
import 'package:clean_flutter/domain/usecases/usecases.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {}

void main() {
  late LocalLoadSurveysSpy local;
  late RemoteLoadSurveysSpy remote;
  late RemoteLoadSurveysWithLocalFallback sut;
  late List<SurveyEntity> remoteSurveys;

  List<SurveyEntity> mockSurveys() => [
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.randomGenerator.string(10),
            dateTime: faker.date.dateTime(),
            didAnswer: faker.randomGenerator.boolean())
      ];

  When mockRemoteCall() => when(() => remote.load());

  void mockRemoteLoad() {
    remoteSurveys = mockSurveys();
    mockRemoteCall().thenAnswer((_) async => remoteSurveys);
  }

  void mockRemoteError(DomainError error) => mockRemoteCall().thenThrow(error);

  void mockSaveLocal() =>
      when(() => local.save(any())).thenAnswer((_) async => {});

  setUp(() {
    remote = RemoteLoadSurveysSpy();
    local = LocalLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(remote: remote, local: local);

    mockRemoteLoad();
    mockSaveLocal();
  });

  test('Should call remote load', () async {
    await sut.load();

    verify(() => remote.load()).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.load();

    verify(() => local.save(remoteSurveys)).called(1);
  });

  test('Should return remote data', () async {
    final surveys = await sut.load();

    expect(surveys, remoteSurveys);
  });

  test('Should rethrow if remote load throws AccessDeniedError', () async {
    mockRemoteError(DomainError.accessDenied);

    final future = sut.load();

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call local fetch on remote error', () async {
    when(() => local.validate()).thenAnswer((_) async => {});
    when(() => local.load()).thenAnswer((_) async => []);
    mockRemoteError(DomainError.unexpected);

    await sut.load();

    verify(() => local.validate()).called(1);
    verify(() => local.load()).called(1);
  });
}

class RemoteLoadSurveysWithLocalFallback implements LoadSurveys {
  final RemoteLoadSurveys remote;
  final LocalLoadSurveys local;

  RemoteLoadSurveysWithLocalFallback({
    required this.remote,
    required this.local,
  });

  Future<List<SurveyEntity>> load() async {
    try {
      final surveys = await remote.load();

      await local.save(surveys);

      return surveys;
    } catch (error) {
      if (error == DomainError.accessDenied) rethrow;

      await local.validate();
      await local.load();
    }

    return [];
  }
}
